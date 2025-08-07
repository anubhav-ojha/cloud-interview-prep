# AWS S3 Interview Questions & Answers

## 1. What is Amazon S3?

**Answer:**

Amazon S3 (Simple Storage Service) is a highly scalable, durable, and secure object storage service. It is designed to store and retrieve any amount of data from anywhere on the web.

---

## 2. What are the storage classes available in S3?

**Answer:**

- **S3 Standard**: Frequent access, low latency, high throughput.
- **S3 Intelligent-Tiering**: Automatically moves data between tiers based on usage.
- **S3 Standard-IA (Infrequent Access)**: For infrequent access with lower cost.
- **S3 One Zone-IA**: Lower-cost IA in a single AZ.
- **S3 Glacier Instant Retrieval**: For archive data with milliseconds access.
- **S3 Glacier Flexible Retrieval**: Archive storage with minutes to hours access.
- **S3 Glacier Deep Archive**: Lowest-cost archive, hours to retrieve.
- **S3 Reduced Redundancy Storage (RRS)**: Legacy, lower durability.

---

## 3. What is an S3 bucket?

**Answer:**

An S3 bucket is a container for storing objects in Amazon S3. Each bucket has a globally unique name and can store unlimited data in the form of key-value pairs (objects).

---

## 4. What is the maximum file size supported by S3?

**Answer:**

- **Single PUT upload**: Up to **5 GB**.
- **Multipart upload**: Up to **5 TB**.

---

## 5. What is S3 Versioning?

**Answer:**

S3 Versioning enables you to keep multiple versions of an object in one bucket. It helps in recovery from accidental deletes or overwrites.

---

## 6. How does S3 ensure data durability and availability?

**Answer:**

S3 is designed for **99.999999999% (11 9’s) durability** and **99.99% availability**. It achieves this by automatically replicating data across multiple facilities in a region.

---

## 7. What are S3 Access Control mechanisms?

**Answer:**

- **Bucket Policies**
- **IAM Policies**
- **Access Control Lists (ACLs)**
- **S3 Block Public Access**
- **Pre-signed URLs**

---

## 8. What is a pre-signed URL in S3?

**Answer:**

A pre-signed URL is a URL that grants temporary access to a private S3 object. It is commonly used to allow users to download or upload files without making the object public.

---

## 9. What is S3 Lifecycle Configuration?

**Answer:**

Lifecycle policies in S3 allow you to automatically transition objects to different storage classes or delete them after a specified period of time to optimize costs.

---

## 10. What is the difference between S3 and EBS/EFS?

**Answer:**

| Feature | S3 | EBS | EFS |
|--------|----|-----|-----|
| Type | Object storage | Block storage | File storage |
| Use Case | Backup, static website, data lake | EC2 storage | Shared file systems |
| Protocol | HTTP/HTTPS | Block-level | NFS |
| Access | Web-based | EC2 attached | EC2 shared |

---

## 11. What is S3 Transfer Acceleration?

**Answer:**

S3 Transfer Acceleration enables fast, secure uploads and downloads to S3 using Amazon CloudFront edge locations.

---

## 12. Can we host a static website on Amazon S3?

**Answer:**

Yes. Amazon S3 can host static websites by enabling **static website hosting** on a bucket and uploading HTML, CSS, JS files.

---

## 13. How is data encrypted in Amazon S3?

**Answer:**

- **At Rest**:
  - SSE-S3 (S3 Managed Keys)
  - SSE-KMS (KMS Managed Keys)
  - SSE-C (Customer Provided Keys)
- **In Transit**: TLS/SSL

---

## 14. How can we secure data in Amazon S3?

**Answer:**

- Enable encryption (SSE)
- Use bucket policies and IAM for access control
- Enable logging and monitoring
- Enable S3 Block Public Access
- Use MFA Delete for versioned buckets

---

## 15. What is an S3 Event Notification?

**Answer:**

S3 can send event notifications to **Lambda**, **SNS**, or **SQS** when specific actions occur (e.g., object creation or deletion).

---