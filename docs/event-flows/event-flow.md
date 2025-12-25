# Event Flow

This document describes a **concrete, end-to-end event flow** in the AWS Cloud-Native Playground, illustrating how services interact asynchronously using managed AWS messaging services.

The purpose is to make **event-driven behavior explicit**, observable, and debuggable.

---

## Flow Overview

**Scenario:**  
A client submits a request to create an order.  
The request is processed synchronously by an API, while downstream processing happens asynchronously.

**High-level flow:**

1. Client sends HTTP request
2. API validates and accepts the request
3. An event is published to SQS
4. A worker consumes the event
5. Processing succeeds or fails
6. Failures are handled via retries or DLQ

---

## Actors

| Actor | Platform | Description |
|-----|--------|------------|
| Client | External | Sends HTTP request |
| spring-api | ECS Fargate | Stateless API, event producer |
| SQS | AWS Managed | Asynchronous message queue |
| go-worker | EKS | Event consumer and processor |
| DLQ | AWS Managed | Stores poison messages |

---

## Step-by-Step Flow

### 1. HTTP Request

The client sends a synchronous HTTP request:

```
POST /orders
```

The request is routed via:
- Application Load Balancer (ALB)
- ECS service (`spring-api`)

---

### 2. Request Handling (ECS)

The API performs:
- Input validation
- Authentication / authorization
- Basic business checks

Once accepted:
- The API **does not** perform heavy processing
- An event is created and published

Example event payload:

```json
{
  "eventType": "OrderCreated",
  "eventVersion": 1,
  "eventId": "uuid",
  "timestamp": "2025-01-01T12:00:00Z",
  "payload": {
    "orderId": "123",
    "amount": 100.00
  }
}
```

---

### 3. Event Publication (SQS)

The API publishes the event to an SQS queue:

- At-least-once delivery
- No ordering guarantees
- Low latency

The HTTP request returns **200 OK** immediately after successful publication.

---

### 4. Event Consumption (EKS)

The `go-worker` service:
- Polls the SQS queue
- Receives messages in batches
- Processes each event independently

Key characteristics:
- Stateless consumer
- Horizontally scalable
- Idempotent processing logic

---

### 5. Success Path

If processing succeeds:
- The message is explicitly deleted from the queue
- Metrics are emitted
- Processing completes asynchronously

No feedback is sent to the original API call.

---

### 6. Failure Path & Retries

If processing fails:
- The message is **not deleted**
- SQS automatically retries delivery
- Visibility timeout prevents immediate redelivery

Retry behavior:
- Configurable max receive count
- Exponential backoff (queue-level)

---

### 7. Dead Letter Queue (DLQ)

After exceeding retry limits:
- The message is moved to a DLQ
- No further automatic processing occurs

DLQ usage:
- Failure inspection
- Root cause analysis
- Manual or automated reprocessing

---

## Failure Characteristics

| Failure Type | Impact |
|------------|-------|
| API failure | Client receives error |
| Worker crash | Message retried |
| Partial processing | Handled via idempotency |
| Downstream outage | Backpressure via queue |

The system favors **failure isolation** over synchronous guarantees.

---

## Observability Points

Metrics and logs are emitted at each stage:

- API request rate
- Event publish success/failure
- Queue depth
- Message age
- Processing latency
- DLQ size

Optional tracing:
- Correlation via `eventId`
- End-to-end visibility across async boundaries

---

## Design Principles Demonstrated

- Loose coupling
- At-least-once delivery
- Horizontal scalability
- Failure isolation
- Managed infrastructure
- Explicit trade-offs

---

## Non-Goals

This flow intentionally avoids:
- Synchronous downstream calls
- Distributed transactions
- Exactly-once semantics
- Cross-service locking

---

## Summary

This event flow demonstrates a **practical, cloud-native async pattern**, suitable for ECS ↔ EKS communication using fully managed AWS services.

The design reflects **real-world distributed system behavior**, prioritizing resilience and operational clarity over theoretical guarantees.