# 📌 Optimizing AWS Lambda Cold Starts for a Latency-Sensitive API

> **Difficulty:** 🟡 Professional
> **Domain:** Compute > Lambda
> **Keywords:** `cold-start`, `provisioned-concurrency`, `snapstart`, `latency`, `p99`

---

## 🔍 Problem Statement

You run a synchronous, customer-facing REST API on API Gateway → Lambda. Median
latency is fine (~40 ms), but the **p99 spikes to 900 ms–3 s** during traffic ramps
and after idle periods. Product has set a **p99 < 250 ms** SLO. An interviewer (or
your own incident review) asks: *what is causing this, and how do you fix it without
simply rewriting everything on containers?*

The spikes are **cold starts** — the latency of initializing a new execution
environment: downloading your code/layers, starting the runtime, and running your
initialization code (imports, SDK clients, DB connection setup) before the handler
runs for the first time.

## 🚀 Solution & Architecture Decision

Cold start latency has several independent contributors; attack them in order of
impact-to-effort.

1. **Shrink the init path (free, do this first).**
   - Trim deployment package / layer size — less to download and unpack.
   - Import only what you use (e.g. import a single `boto3` client, not heavy
     frameworks). In Python/Node, top-level imports dominate init time.
   - Instantiate SDK clients and DB connections **once, outside the handler**, so
     warm invocations reuse them.

2. **Pick a fast runtime for the workload.** Interpreted runtimes (Python, Node.js)
   and Go have low init cost. The JVM and .NET have historically high init cost —
   which is exactly what **SnapStart** addresses.

3. **Lambda SnapStart (best for JVM/.NET/Python, no per-hour cost).** Lambda takes a
   Firecracker snapshot of the initialized environment and restores from it, cutting
   init to tens of milliseconds. Available for Java, .NET, and Python managed
   runtimes. Ideal when you can't or won't pay for always-warm capacity. Caveat:
   uniqueness/state captured at snapshot time (e.g. random seeds, cached
   credentials) must be regenerated on restore via runtime hooks.

4. **Provisioned Concurrency (PC) for hard latency SLOs.** PC keeps *N* environments
   initialized and ready, so requests served by them incur **no cold start**. Pair
   it with **Application Auto Scaling** (target tracking or scheduled) so you buy
   warm capacity only around known traffic, not 24/7.

### Decision Drivers

- **Hard p99 SLO** on a synchronous path → predictable warm capacity matters more
  than marginal cost.
- **Spiky, partly predictable traffic** → scheduled/auto-scaled PC beats a flat,
  always-on fleet.
- **Runtime already Python** → SnapStart is a low-cost first lever; PC covers the
  residual tail during scale-out beyond provisioned count.
- Avoid a full re-platform to containers unless the workload is long-running or
  needs >15 min execution / >10 GB memory.

### Architecture Diagram (Optional)

```text
                         ┌─────────────────────────────┐
Client ──▶ API Gateway ──▶  Lambda alias "live"         │
                         │   ├─ Provisioned Concurrency  │  ◀── warm, 0 cold start
                         │   │   (auto-scaled 10→50)     │
                         │   └─ On-demand spillover      │  ◀── SnapStart reduces
                         │       (beyond PC count)       │       these cold starts
                         └─────────────────────────────┘
```

## 🛠️ Code / Configuration

Terraform enabling **Provisioned Concurrency on a versioned alias** with target-
tracking auto scaling (PC must point at a published version or alias, never `$LATEST`):

```hcl
resource "aws_lambda_function" "api" {
  function_name = "orders-api"
  role          = aws_iam_role.lambda.arn
  handler       = "app.handler"
  runtime       = "python3.12"
  memory_size   = 1024 # more memory = more vCPU = faster init & execution
  filename      = data.archive_file.api.output_path
  publish       = true # publishes a new version on each change
}

resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = aws_lambda_function.api.function_name
  function_version = aws_lambda_function.api.version
}

# Baseline warm capacity on the alias
resource "aws_lambda_provisioned_concurrency_config" "live" {
  function_name                     = aws_lambda_function.api.function_name
  qualifier                         = aws_lambda_alias.live.name
  provisioned_concurrent_executions = 10
}

# Scale provisioned concurrency 10 -> 50 based on utilization
resource "aws_appautoscaling_target" "pc" {
  service_namespace  = "lambda"
  resource_id        = "function:${aws_lambda_function.api.function_name}:${aws_lambda_alias.live.name}"
  scalable_dimension = "lambda:function:ProvisionedConcurrency"
  min_capacity       = 10
  max_capacity       = 50
}

resource "aws_appautoscaling_policy" "pc" {
  name               = "lambda-pc-target-tracking"
  service_namespace  = aws_appautoscaling_target.pc.service_namespace
  resource_id        = aws_appautoscaling_target.pc.resource_id
  scalable_dimension = aws_appautoscaling_target.pc.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 0.70 # keep utilization ~70%
    predefined_metric_specification {
      predefined_metric_type = "LambdaProvisionedConcurrencyUtilization"
    }
  }
}
```

For Java/.NET/Python you can instead (or additionally) enable SnapStart — no PC cost:

```hcl
resource "aws_lambda_function" "api" {
  # ...
  snap_start {
    apply_on = "PublishedVersions"
  }
}
```

## ⚖️ Trade-offs & Alternatives Considered

| Option | Pros | Cons | Cost Impact |
| -------- | ------ | ------ | ------------- |
| **Lambda + Provisioned Concurrency** (chosen) | Eliminates cold starts on warm capacity; hits hard p99 SLO; keeps serverless ops model; auto-scales to traffic | Pay for provisioned time even when idle; must manage a scaling schedule; PC beyond the provisioned count still cold-starts | Medium — PC billed per GB-second of provisioned time + normal invoke cost |
| **Lambda + SnapStart** | No per-hour cost; big win for JVM/.NET/Python init; simple to enable | Not for all runtimes; snapshot state pitfalls (seeds, connections) need hooks; doesn't fully eliminate the tail under burst | Low — no extra charge beyond standard invocation |
| **Lambda on-demand, tuned only** | Zero extra cost; simplest | Tail latency remains during ramps/idle; may miss a strict p99 SLO | Lowest — standard invoke cost only |
| **ECS Fargate (always-on service)** | No cold starts at all; long-running/large workloads; steady predictable latency | Always paying for running tasks; you own scaling, patching, load balancing, health checks; more ops | Higher at low/spiky traffic; can be cheaper at sustained high traffic |

**Rule of thumb:** for spiky, sub-15-minute, request/response workloads with a strict
SLO, Lambda + auto-scaled PC (plus SnapStart where supported) is usually cheaper and
simpler than a warm Fargate fleet. Once traffic is *sustained and high*, a
right-sized Fargate service can win on cost — that's the crossover to watch.

## 💰 Cost Estimation

Illustrative only — validate with the [AWS Pricing Calculator](https://calculator.aws/).
Assume `us-east-1`, 1024 MB (1 GB) functions, ~50 ms average billed duration.

- **On-demand invocations:** 10M requests/month ≈ **$2.00** in requests
  (`$0.20 / 1M`) + ~**$8.34** in compute (`10M × 0.05 s × 1 GB × $0.0000166667/GB-s`)
  ≈ **~$10/month** — but with a cold-start tail.
- **Provisioned Concurrency, 10 units 24/7:** `10 × 1 GB × 2,592,000 s ×
  $0.0000041667/GB-s` ≈ **~$108/month** for warm capacity, *plus* a lower per-invoke
  compute rate on PC-served requests. Auto-scaling PC only during a 12h business day
  roughly halves this to **~$55/month**.
- **Fargate equivalent (2 always-on tasks, 0.5 vCPU / 1 GB):** ≈ **~$36/month** per
  task-pair baseline, before load balancer (~$16–20/month for an ALB) and scaling
  headroom.

Takeaway: schedule/auto-scale PC to match real traffic; don't leave large PC running
overnight, and prefer SnapStart first where the runtime supports it.

## 📚 References

- [AWS Lambda — Provisioned Concurrency](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html)
- [AWS Lambda — SnapStart](https://docs.aws.amazon.com/lambda/latest/dg/snapstart.html)
- [Operating Lambda: Performance optimization](https://aws.amazon.com/blogs/compute/operating-lambda-performance-optimization-part-1/)
- [AWS Lambda Pricing](https://aws.amazon.com/lambda/pricing/)
