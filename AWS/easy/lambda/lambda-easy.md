# AWS Lambda Interview Questions & Answers

## 1. What is AWS Lambda?

**Answer:**

AWS Lambda is a serverless compute service provided by AWS that lets you run code without provisioning or managing servers. You only pay for the compute time consumed — there is no charge when your code is not running.

---

## 2. What are the key features of AWS Lambda?

**Answer:**

- **Event-driven execution**: Triggers from S3, DynamoDB, SNS, API Gateway, etc.
- **Automatic scaling**: Scales automatically based on the number of events.
- **Pay-per-use**: Charged based on the number of requests and execution duration.
- **Short-lived tasks**: Max execution timeout is 15 minutes.
- **Multiple language support**: Supports Node.js, Python, Java, Go, Ruby, .NET, and custom runtimes.

---

## 3. How do you trigger a Lambda function?

**Answer:**

Lambda functions can be triggered by:
- **AWS services**: e.g., S3 (file uploads), DynamoDB (data changes), API Gateway (HTTP requests), CloudWatch (events/logs).
- **Custom events**: Through SDKs or CLI.
- **Manual invocation**: Via AWS Console or Lambda test events.

---

## 4. What is the AWS Lambda execution role?

**Answer:**

An **IAM Role** assigned to a Lambda function that grants it permission to access other AWS resources (e.g., read from S3, write to DynamoDB). This is also known as the **Lambda execution role**.

---

## 5. How does AWS Lambda handle concurrency?

**Answer:**

Each event is processed by a separate instance of the function. Lambda automatically scales to handle the number of incoming events, up to the **account's concurrency limit** (default: 1,000). You can increase it or configure **reserved concurrency** and **provisioned concurrency** for more control.

---

## 6. What is the difference between cold start and warm start in Lambda?

**Answer:**

- **Cold Start**: Occurs when Lambda spins up a new container to handle the request. This takes additional time (latency).
- **Warm Start**: Occurs when an already initialized container handles the request, resulting in faster response times.

---

## 7. What is the maximum execution timeout for a Lambda function?

**Answer:**

The maximum timeout for a Lambda function is **15 minutes (900 seconds)**.

---

## 8. How can you deploy a Lambda function?

**Answer:**

- **AWS Console**
- **AWS CLI**
- **AWS SDKs**
- **Infrastructure as Code (IaC)** tools like:
  - AWS CloudFormation
  - AWS CDK
  - Terraform
  - Serverless Framework
- **CI/CD pipelines** using CodePipeline, GitHub Actions, etc.

---

## 9. How do environment variables work in Lambda?

**Answer:**

You can define **key-value pairs** as environment variables for your Lambda function. These variables can be accessed from within the code and can be encrypted using **AWS KMS**.

---

## 10. How do you monitor and debug a Lambda function?

**Answer:**

- **Amazon CloudWatch Logs**: Automatically stores logs from your function.
- **CloudWatch Metrics**: Tracks invocations, durations, error count, etc.
- **AWS X-Ray**: Helps in tracing and debugging distributed applications.

---

## 11. Can AWS Lambda connect to a VPC?

**Answer:**

Yes. Lambda can be configured to access resources within a **VPC** (like RDS or EC2) by attaching it to the VPC’s subnets and security groups. This, however, may slightly increase startup time.

---

## 12. What is the size limit of a Lambda deployment package?

**Answer:**

- **Direct upload (ZIP file)**: Max 50 MB (compressed).
- **Via S3**: Max 250 MB (uncompressed, including dependencies).
- **Layers**: Up to 5 layers, 250 MB each (uncompressed).