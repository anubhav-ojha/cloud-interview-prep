# AWS Scenario-Based Interview Questions & Answers

---

## 1. How would you design a highly available serverless API using AWS Lambda and API Gateway, and what are the potential pitfalls?

**Answer:**  
- **Architecture:**  
  - Use API Gateway as the front door and AWS Lambda for backend compute.
  - Choose regional or edge-optimized endpoints for global reach.
- **Scalability & Availability:**  
  - Lambda scales automatically per request.
  - API Gateway supports high availability.
- **Data Layer:**  
  - Use DynamoDB for NoSQL backend with auto-scaling and DAX (caching) for low latency.
- **Error Handling & Retries:**  
  - Configure Dead Letter Queues (DLQs) using SQS or SNS for failed Lambda executions.
  - Set proper retry policies.
- **Cold Starts:**  
  - Minimize with Provisioned Concurrency for critical Lambdas.
- **Security:**  
  - Use IAM roles for Lambda → DynamoDB access.
  - Use Cognito or JWT authorizers for API Gateway authentication.
- **Monitoring:**  
  - Integrate with CloudWatch Logs & Metrics.
  - Enable AWS X-Ray for tracing.

**Potential Pitfalls:**
- Cold start latency if not tuned.
- Hitting Lambda concurrency limits.
- Large payloads (API Gateway has a 10 MB limit).
- Improper error handling leading to retry storms on DynamoDB.

---

## 2. How would you optimize a Python-based Lambda function that is processing millions of S3 events daily?

**Answer:**  
- **Batching:**  
  - Use S3 → SQS → Lambda to batch messages, reducing invocations.
- **Memory & CPU Tuning:**  
  - Lambda’s CPU is tied to memory; allocate more memory to reduce execution time and cost.
- **Efficient Python Code:**  
  - Use `boto3` clients instead of resources (faster).
  - Reuse DB connections outside the handler to avoid re-init cost.
  - Use libraries like `aioboto3` for async I/O if multiple S3 calls are required.
- **Concurrency Control:**  
  - Use SQS FIFO + batch size to throttle load.
- **Monitoring:**  
  - Track Duration, Throttles, DLQ errors via CloudWatch.

---

## 3. Can you explain how you’d implement an event-driven workflow with Step Functions, Lambda, and DynamoDB?

**Answer:**  
Suppose building an order processing workflow:

1. **API Gateway → Lambda:** Receives order request and writes to DynamoDB.
2. **Step Functions orchestrate the process:**
   - **Task 1:** Validate payment (Lambda).
   - **Task 2:** Reserve inventory (Lambda → DynamoDB).
   - **Task 3:** Send confirmation (SNS).
3. **Retry & Error Handling:**  
   - Step Functions allow built-in retries with exponential backoff for transient errors.
4. **State Management:**  
   - DynamoDB maintains order state; Step Functions handle execution flow.
5. **Scalability:**  
   - Each task is serverless and scales independently.

**Why Step Functions?**
- Handles long-running processes (up to 1 year).
- Reduces “glue code” inside Lambdas.
- Provides visualization & traceability.

---

## 4. What are some best practices for securing AWS Lambda and API Gateway applications?

**Answer:**  
- **IAM Least Privilege:**  
  - Grant Lambdas only the permissions they need (e.g., `dynamodb:PutItem` instead of `dynamodb:*`).
- **API Gateway Security:**  
  - Use IAM auth, Cognito user pools, or JWT custom authorizers.
  - Enable WAF to block SQLi/XSS/DDoS.
- **Secrets Management:**  
  - Use AWS Secrets Manager or SSM Parameter Store; never hardcode credentials.
- **Encryption:**  
  - S3 buckets with SSE.
  - DynamoDB with KMS keys.
- **Network Security:**  
  - Place Lambdas in a VPC if accessing RDS/ElastiCache.
- **Logging & Monitoring:**  
  - Enable CloudWatch logs, alarms, and GuardDuty for anomaly detection.

---

## 5. How would you build a CI/CD pipeline for deploying Python microservices on AWS Lambda?

**Answer:**  
- **Version Control:**  
  - Store code in GitHub or CodeCommit.
- **Pipeline Tool:**  
  - Use AWS CodePipeline or GitHub Actions.
- **Build Stage:**  
  - Use CodeBuild to install dependencies (from `requirements.txt`).
  - Run `pytest`/`flake8` for unit + linting checks.
- **Packaging:**  
  - Zip Lambda function with dependencies.
  - Optionally use Lambda Layers for shared dependencies.
- **Deployment:**  
  - Deploy via SAM, Serverless Framework, or Terraform.
  - Use canary or linear deployments with CodeDeploy to reduce risk.
- **Post-Deployment Tests:**  
  - Run integration tests against API Gateway endpoints.
- **Monitoring:**  
  - Rollback automatically if CloudWatch alarms fire (e.g., high 5xx errors).