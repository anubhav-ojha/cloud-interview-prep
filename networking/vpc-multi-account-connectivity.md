# 📌 Multi-Account VPC Connectivity: Transit Gateway vs VPC Peering vs PrivateLink

> **Difficulty:** 🟡 Professional
> **Domain:** Networking > VPC / Transit Gateway
> **Keywords:** `transit-gateway`, `vpc-peering`, `privatelink`, `multi-account`, `landing-zone`

---

## 🔍 Problem Statement

Your organization is growing into an AWS multi-account landing zone (separate
accounts for prod, staging, shared services, security). Teams need VPCs to talk to
each other and to shared services (CI/CD, logging, a central artifact store). The
interview / design question: **How do you connect VPCs across many accounts, and how
do you choose between VPC Peering, Transit Gateway, and PrivateLink?**

The wrong choice shows up later as an unmanageable mesh of peering connections, an
overly broad network blast radius, or paying to route traffic you only needed to
expose as a single service.

## 🚀 Solution & Architecture Decision

These three are **not interchangeable** — they solve different problems:

- **VPC Peering** — 1:1, non-transitive network-level connection between two VPCs.
  Full CIDR-to-CIDR routing. Great for a *small, stable* number of VPCs. Becomes a
  combinatorial mess at scale: connecting *n* VPCs fully meshed needs
  `n(n-1)/2` peerings.
- **Transit Gateway (TGW)** — a regional hub-and-spoke router. Attach many VPCs (and
  VPN/Direct Connect) to one TGW; use **route tables** on the TGW to control which
  spokes can reach which. Supports transitive routing and cross-region peering. The
  default choice for connecting *many* VPCs/accounts.
- **PrivateLink (VPC endpoints + endpoint services)** — exposes a **single service**
  (behind an NLB) privately to consumer VPCs, without connecting the whole network.
  Consumers reach the service via an interface endpoint (ENI) in their own subnets.
  CIDRs can even overlap because it's service-level, not network-level.

### Decision Drivers

- **How many VPCs, and how dynamic?** A handful and static → peering may be fine.
  Growing landing zone → TGW.
- **Do you need full network reachability or just one service?** Full network → TGW/
  peering. One service (e.g. a shared payments API) → PrivateLink, for least
  exposure.
- **Segmentation / blast radius.** TGW route tables let you isolate environments
  (e.g. prod cannot reach dev) centrally. Peering gives you all-or-nothing per pair.
- **Overlapping CIDRs.** Peering and TGW require non-overlapping CIDRs for routed
  traffic; PrivateLink sidesteps this.
- **Cost model.** Peering has no hourly fee (data transfer only). TGW adds a per-
  attachment hour + per-GB processing fee. PrivateLink adds per-endpoint hour +
  per-GB.

### Architecture Diagram (Optional)

```text
        Account A (prod)        Account B (staging)     Account C (shared svcs)
        ┌───────────┐           ┌───────────┐           ┌────────────────────┐
        │  VPC-A     │          │  VPC-B     │           │ VPC-C: logging, CI  │
        └─────┬─────┘           └─────┬─────┘            └─────────┬──────────┘
              │ attachment              │ attachment                │ attachment
              └───────────────┬─────────┴───────────────┬──────────┘
                              ▼                          ▼
                     ┌─────────────────────────────────────────┐
                     │        Transit Gateway (regional)        │
                     │  route tables enforce prod⇎staging deny  │
                     └─────────────────────────────────────────┘

   PrivateLink (for a single shared service, least exposure):
     Consumer VPC ──interface endpoint(ENI)──▶ Endpoint Service ──NLB──▶ Provider service
```

## 🛠️ Code / Configuration

Terraform: a Transit Gateway shared across accounts via AWS RAM, with two VPC
attachments and a route:

```hcl
# --- Shared services account: create + share the TGW ---
resource "aws_ec2_transit_gateway" "hub" {
  description                     = "org-hub"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable" # manage segmentation explicitly
  default_route_table_propagation = "disable"
}

resource "aws_ram_resource_share" "tgw" {
  name                      = "tgw-share"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.hub.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

resource "aws_ram_principal_association" "org" {
  principal          = "arn:aws:organizations::111122223333:organization/o-exampleorgid"
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# --- Spoke account: attach a VPC and route to the hub ---
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  vpc_id             = aws_vpc.spoke.id
  subnet_ids         = [aws_subnet.tgw_a.id, aws_subnet.tgw_b.id] # one /28 per AZ
}

resource "aws_route" "to_tgw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "10.0.0.0/8" # other VPCs' supernet
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}
```

## ⚖️ Trade-offs & Alternatives Considered

| Option | Pros | Cons | Cost Impact |
| -------- | ------ | ------ | ------------- |
| **Transit Gateway** (chosen for many VPCs) | Scales to hundreds of VPCs/accounts; central route tables for segmentation; transitive; supports VPN/DX + cross-region | Per-attachment hourly + per-GB processing fee; another component to operate | Medium — ~$0.05/attachment-hr + ~$0.02/GB processed (region-dependent) |
| **VPC Peering** | No hourly fee; simple for a few VPCs; full-bandwidth, low latency | Non-transitive; `n(n-1)/2` connections; no central segmentation; hard to manage at scale | Low — data transfer only |
| **PrivateLink** | Exposes one service with minimal surface; works with overlapping CIDRs; consumer/provider isolation | Service-level only (not general networking); NLB + endpoint plumbing; per-endpoint cost | Medium — per-endpoint hour + per-GB; multiplies with many consumers |

**Common hybrid:** TGW for general east-west connectivity between environments, and
PrivateLink for a few sensitive shared services you want to expose narrowly (so prod
can call a shared "payments" service without the two networks being fully routable).

## 💰 Cost Estimation

Illustrative, `us-east-1` order-of-magnitude — confirm with the
[AWS Pricing Calculator](https://calculator.aws/):

- **Transit Gateway:** ~**$0.05 per attachment-hour** ≈ ~$36/month per VPC
  attachment, **plus ~$0.02 per GB** processed. 10 VPCs + 5 TB/month ≈
  `10 × $36` + `5,000 GB × $0.02` ≈ **~$460/month**.
- **VPC Peering:** **$0** hourly; you pay inter-AZ/inter-Region data transfer only
  (e.g. ~$0.01–$0.02/GB same-region cross-AZ). Cheapest for a few VPCs, but
  operationally expensive at scale.
- **PrivateLink:** ~**$0.01 per endpoint-hour per AZ** (~$7–22/month per endpoint
  depending on AZ count) **plus ~$0.01/GB**. Cost grows with number of consumer
  endpoints, not total network size.

## 📚 References

- [Building a scalable and secure multi-VPC AWS network infrastructure (whitepaper)](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/welcome.html)
- [Amazon VPC — Transit Gateways](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html)
- [VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html)
- [AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/what-is-privatelink.html)
