# AWS DynamoDB – Interview Questions & Answers

---

### 1. What is Amazon DynamoDB and when should you use it?

**Answer:**  
Amazon DynamoDB is a fully managed, serverless NoSQL database service provided by AWS that offers single-digit millisecond latency at any scale. It supports both document and key-value data models.

**You should use DynamoDB when:**
- You need low latency reads and writes at scale.
- Your workload is highly scalable and can handle fluctuating traffic.
- You want automatic scaling and no infrastructure management.
- You require multi-Region replication for global applications.

**Example use cases:**
- E-commerce product catalogs
- Gaming leaderboards
- IoT device data storage
- Real-time bidding systems

---

### 2. Explain DynamoDB’s data model.

**Answer:**  
DynamoDB stores data in tables, which consist of:
- **Items** (analogous to rows in RDBMS)
- **Attributes** (analogous to columns)

**Key components:**
- **Primary Key:** Uniquely identifies an item.
  - Partition key only (simple primary key)
  - Partition key + sort key (composite primary key)
- **Secondary Indexes:**
  - **Global Secondary Index (GSI):** Can query on any attribute, different partition/sort keys.
  - **Local Secondary Index (LSI):** Same partition key as base table, different sort key.

---

### 3. How does DynamoDB partition data and why is it important?

**Answer:**  
- DynamoDB partitions data based on the hash value of the partition key.
- Each partition can store up to 10 GB of data.
- Read and write capacity is distributed across partitions.
- Hot partitions occur when too many requests go to the same partition key, causing throttling.

**Best Practices to avoid hot partitions:**
- Use high-cardinality partition keys.
- Add random suffixes or prefixes to keys.
- Use adaptive capacity where possible.

---

### 4. What are Read and Write Capacity Units in DynamoDB?

**Answer:**

- **Read Capacity Unit (RCU):**
  - 1 RCU = One strongly consistent read of up to 4 KB per second.
  - 1 RCU = Two eventually consistent reads of up to 4 KB per second.
- **Write Capacity Unit (WCU):**
  - 1 WCU = One write of up to 1 KB per second.

**Example:**  
If you read 8 KB with strong consistency → 2 RCUs per read.

---

### 5. What is the difference between On-Demand and Provisioned capacity modes?

| Feature            | Provisioned Mode                | On-Demand Mode                  |
|--------------------|---------------------------------|----------------------------------|
| Capacity Setting   | Manually set RCUs & WCUs        | Automatically scales with traffic|
| Billing            | Pay for provisioned capacity    | Pay per request                  |
| Use Case           | Predictable workloads           | Unpredictable workloads          |
| Scaling            | Manual or Auto Scaling          | Fully automatic                  |

---

### 6. How do Global Secondary Index (GSI) and Local Secondary Index (LSI) differ?

| Feature         | GSI                                 | LSI                              |
|-----------------|-------------------------------------|----------------------------------|
| Partition Key   | Can be different from base table    | Same as base table               |
| Sort Key        | Can be different                    | Different from base table        |
| Data Size Limit | Independent from base table         | 10 GB per partition key          |
| Creation Time   | Can be created anytime              | Must be created at table creation|

---

### 7. How does DynamoDB handle eventual and strong consistency?

**Answer:**
- **Strongly Consistent Reads:** Returns the latest committed value; higher latency and RCU usage.
- **Eventually Consistent Reads:** Might return stale data; consumes half the RCUs.
- **Transactional Reads/Writes:** Uses ACID properties for mission-critical workloads.

---

### 8. Explain DynamoDB Streams and a practical use case.

**Answer:**  
DynamoDB Streams captures item-level changes in a table (insert, update, delete) and stores them in an ordered sequence for up to 24 hours.

**Can be consumed by:**  
- AWS Lambda
- Kinesis
- Custom consumers

**Use cases:**
- Real-time analytics
- Event-driven processing
- Cross-region replication
- Audit logging

---

### 9. How do you design a DynamoDB schema for an e-commerce platform with products and orders?

**Answer:**  
**Best Practice:** Use single-table design with composite keys.

**Example Table Design:**

| PK (Partition Key) | SK (Sort Key)   | Attributes         |
|--------------------|-----------------|--------------------|
| USER#123           | PROFILE         | Name, Email        |
| USER#123           | ORDER#20230801  | Order details      |
| PRODUCT#456        | DETAILS         | Name, Price, Stock |
| PRODUCT#456        | REVIEW#987      | Rating, Comment    |

**Benefits:**
- All related data grouped by partition key.
- Efficient queries with Query API instead of Scan.

---

### 10. What are common performance optimization techniques in DynamoDB?

**Answer:**
- Use Query over Scan – Query is more efficient since it targets specific partitions.
- Select Appropriate Partition Keys – Avoid hot keys.
- Use GSI for Alternate Query Patterns.
- BatchWriteItem and BatchGetItem – Reduce network calls.
- DAX (DynamoDB Accelerator) – In-memory cache for microsecond latency.
- Enable Auto Scaling – Adjust capacity units dynamically.
- Use Projection Expressions – Fetch