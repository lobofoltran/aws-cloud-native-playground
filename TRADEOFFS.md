# Architectural Trade-offs

This document records the **key architectural trade-offs** made in the AWS Cloud-Native Playground.

The goal is not to claim a universally “correct” architecture, but to **explicitly document decisions, alternatives, and their consequences**, following a platform engineering mindset.

---

## ECS Fargate vs EKS

### ECS Fargate

**Why ECS**
- Fully managed container runtime
- No cluster or node management
- Tight AWS integration
- Lower operational complexity

**Pros**
- Minimal operational overhead
- Fast time-to-production
- Native scaling and load balancing
- Ideal for simple, stateless services

**Cons**
- Limited extensibility
- Less control over networking
- Vendor lock-in to AWS
- Not suitable for complex orchestration needs

**When ECS is the better choice**
- Simple APIs
- Background workers
- Teams prioritizing delivery speed over flexibility

---

### EKS (Kubernetes)

**Why EKS**
- Full Kubernetes API
- Cloud-agnostic orchestration model
- Rich ecosystem
- Advanced traffic and policy control

**Pros**
- Powerful scheduling and scaling
- Strong observability ecosystem
- Fine-grained networking and security
- Portable Kubernetes knowledge

**Cons**
- Higher operational complexity
- Longer setup and learning curve
- Additional cost for control plane
- Requires Kubernetes expertise

**When EKS is the better choice**
- Complex distributed systems
- Advanced networking requirements
- Teams with platform engineering maturity

---

## Why ECS and EKS Together?

Using both ECS and EKS in the same platform is an **intentional learning-driven decision**.

**This approach allows:**
- Direct comparison of operational models
- Understanding when Kubernetes is overkill
- Evaluating managed simplicity vs flexibility
- Building pragmatic platform intuition

This is **not** a recommendation for production systems by default.

---

## SQS vs Kafka

### Amazon SQS

**Why SQS**
- Fully managed
- Simple operational model
- Native AWS integration
- Predictable cost

**Pros**
- No broker management
- Built-in retries and DLQs
- High availability by default
- Excellent for task-based async workflows

**Cons**
- No message replay
- Limited ordering guarantees
- Not suitable for event streaming use cases

**Ideal use cases**
- Async tasks
- Service decoupling
- Background processing
- ECS ↔ EKS communication

---

### Kafka

**Why Kafka (optional)**
- High-throughput event streaming
- Event replay and retention
- Strong ordering guarantees

**Pros**
- Durable event logs
- Fan-out at scale
- Event-driven architectures

**Cons**
- High operational cost
- Complex scaling and tuning
- Requires deep operational expertise
- Overkill for many use cases

**When Kafka makes sense**
- Streaming data
- Event sourcing
- Analytics pipelines

---

## Why SQS as the Core Messaging System?

SQS is chosen as the **primary messaging mechanism** because:
- It aligns with managed-service principles
- It reduces operational burden
- It fits most async communication needs

Kafka is used **only as a comparative learning tool**, not as a default dependency.

---

## Infrastructure as Code: Terraform

**Why Terraform**
- Declarative infrastructure
- Strong AWS provider support
- Mature ecosystem
- Environment isolation

**Trade-offs**
- Slower feedback loop than click-ops
- Requires upfront design
- State management complexity

The benefits outweigh the costs for any non-trivial platform.

---

## Event-Driven vs Synchronous Communication

### Event-Driven

**Pros**
- Loose coupling
- Failure isolation
- Horizontal scalability

**Cons**
- Harder debugging
- Eventual consistency
- Requires idempotency

### Synchronous (HTTP)

**Pros**
- Simpler mental model
- Easier debugging
- Strong consistency

**Cons**
- Tight coupling
- Cascading failures
- Scaling bottlenecks

This platform favors **event-driven communication** wherever possible.

---

## Exactly-Once Delivery

Exactly-once delivery is **not achievable in practice** in distributed systems.

**Mitigation strategies used:**
- At-least-once delivery
- Idempotent consumers
- DLQs
- Clear failure boundaries

This reflects real-world system behavior rather than theoretical guarantees.

---

## Managed Services vs Self-Managed Infrastructure

**Managed services are preferred** because:
- Reduced operational burden
- Higher reliability
- Faster iteration

**Trade-off**
- Less control
- Vendor lock-in
- Higher per-unit cost

For this project, **operational clarity outweighs control**.

---

## Cost Awareness

This project is **not optimized for cost**, but trade-offs are acknowledged:

- ECS Fargate simplifies operations but may cost more at scale
- EKS adds control plane and node overhead
- SQS is inexpensive and predictable
- Kafka is costly and should be justified

Cost visibility is part of platform maturity.

---

## Final Considerations

The architectural choices in this project prioritize:
- Learning and exploration
- Platform engineering principles
- Explicit trade-off documentation
- Managed services over manual control

This document exists to **make decisions visible**, not to defend them as universally correct.
