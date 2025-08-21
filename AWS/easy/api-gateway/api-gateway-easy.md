# AWS API Gateway – Interview Questions & Answers

---

### 1. What is Amazon API Gateway and why is it used?

**Answer:**  
Amazon API Gateway is a fully managed service that helps you create, publish, secure, and monitor APIs at scale. It acts as a "front door" for applications to access data, business logic, or functionality from backend services like AWS Lambda, EC2, or on-premise systems.

**Why it's used:**
- Simplifies API development and deployment.
- Provides security features like authentication, authorization, and throttling.
- Handles tasks like request/response transformation, caching, and monitoring.
- Scales automatically without needing to manage servers.

> **Interview Tip:** Mention that it enables serverless architectures and is widely used in microservices designs.

---

### 2. What types of endpoints can you create with API Gateway?

**Answer:**  
API Gateway supports three types of endpoints:
- **Regional Endpoint:** Deployed in a specific AWS region; recommended for low-latency, region-specific use cases.
- **Edge-Optimized Endpoint:** Deployed globally through Amazon CloudFront; best for clients distributed across multiple regions.
- **Private Endpoint:** Accessible only within a VPC using VPC endpoints (AWS PrivateLink); used for internal APIs.

> **Interview Tip:** Explain when you would use each type (e.g., Edge-Optimized for public APIs, Private for internal systems).

---

### 3. How does API Gateway integrate with AWS Lambda?

**Answer:**  
API Gateway can directly trigger a Lambda function when an HTTP request is made. The flow looks like this:
1. A client sends a request → API Gateway receives it.
2. API Gateway invokes the Lambda function with the event payload.
3. Lambda processes the request and returns a response → API Gateway formats it and sends it back to the client.

> **Interview Tip:** Highlight that this allows serverless backends without provisioning servers.

---

### 4. What is the difference between REST API and HTTP API in API Gateway?

| Feature      | REST API | HTTP API |
|--------------|----------|----------|
| Feature set  | Full set: API keys, usage plans, request validation, caching, custom authorizers | Lightweight: Lower latency, cheaper, limited features |
| Cost         | Higher   | Lower    |
| Protocol     | Supports REST + WebSocket APIs | Supports HTTP + WebSocket APIs |
| Best for     | Complex APIs with advanced features | Simple, cost-effective APIs |

> **Interview Tip:** Emphasize that HTTP APIs are cheaper and faster, but REST APIs provide advanced enterprise features.

---

### 5. How does API Gateway handle authentication and authorization?

**Answer:**  
API Gateway supports multiple mechanisms:
- **IAM Roles and Policies:** For internal AWS-to-AWS calls.
- **Lambda Authorizers (Custom Authorizers):** Run custom logic (e.g., token validation against DB).
- **Amazon Cognito Authorizers:** For user authentication and token validation via Cognito User Pools.
- **Resource Policies:** Control access at the API level.

> **Interview Tip:** Say that you would typically use Cognito for user management, IAM for AWS services, and Lambda Authorizers for custom logic.

---

### 6. What are usage plans and API keys in API Gateway, and why would you use them?

**Answer:**  
- **API Keys:** Unique identifiers given to clients to call APIs.
- **Usage Plans:** Define limits (throttling & quotas) for API keys. Example: 1000 requests/day.

**Why use them?**
- Control API consumption.
- Monetize APIs by offering different tiers (Free vs Premium).
- Protect backend systems from overuse.

> **Interview Tip:** Mention monetization and rate-limiting as strong use cases.

---

### 7. How does caching work in API Gateway?

**Answer:**  
API Gateway can cache responses at the API stage level using an in-memory cache.
- Cache can be enabled with TTL (Time-To-Live).
- Reduces load on backend services by serving repeated responses.
- Improves performance and reduces latency for frequently requested data.

> **Interview Tip:** Add that caching is charged based on cache size and is useful when backend calls are expensive.

---

### 8. What is the difference between a “proxy integration” and a “non-proxy (custom) integration” in API Gateway?

**Answer:**  
- **Proxy Integration (Lambda/HTTP Proxy):**
  - API Gateway forwards the entire request to the backend (Lambda/HTTP service).
  - Backend handles request processing and response formatting.
  - Faster setup, less configuration.

- **Non-Proxy (Custom) Integration:**
  - API Gateway transforms the request/response using mapping templates.
  - Useful when backend expects specific input/output formats.
  - More control but requires extra configuration.

> **Interview Tip:** Say proxy = simple & flexible, custom = fine-grained control.

---

### 9. How does throttling and quota management work in API Gateway?

**Answer:**  
API Gateway provides two levels of throttling:
- **Per-Method Throttling:** Limits requests per second at the method level.
- **Usage Plan Quotas:** Restricts total requests per day/week/month via API keys.

Default limits: 10,000 RPS (requests per second) per account (soft limit).

Prevents backend overload and ensures fair usage.

> **Interview Tip:** Relate it to DDoS protection and cost control.

---

### 10. How can you monitor and troubleshoot an API deployed in API Gateway?

**Answer:**  
You can use multiple AWS tools:
- **CloudWatch Logs:** Capture detailed request/response and errors.
- **CloudWatch Metrics:** Track latency, 4xx/5xx error rates, integration latency.
- **AWS X-Ray:** Trace requests end-to-end across services.
- **Access Logs:** Enable access logging for debugging.

> **Interview Tip:** Say monitoring is crucial for production APIs to detect issues and optimize performance.