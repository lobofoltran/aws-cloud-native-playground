# Architecture

This document describes the architectural design of the **AWS Cloud-Native Playground**, focusing on **managed AWS services**, **event-driven communication**, and **modern container orchestration**.

The architecture is intentionally designed to compare **ECS Fargate** and **EKS** side by side, while maintaining a consistent, cloud-native operational model.

---

## Architectural Goals

- Explore AWS **managed compute models** in practice
- Compare **ECS vs EKS** from an operational perspective
- Build an **event-driven system** with loose coupling
- Avoid direct server management (no SSH, no pets)
- Keep infrastructure **fully declarative and reproducible**

---

## High-Level Overview

The platform consists of multiple services deployed across different compute paradigms, connected via managed messaging services.

**Key characteristics:**
- Single AWS account
- Single VPC
- Private subnets for all workloads
- Internet exposure via Application Load Balancer (ALB)
- Asynchronous communication via SQS and EventBridge

---

## Compute Layer

### ECS Fargate

**Purpose**
- Run stateless containerized services without Kubernetes overhead

**Typical workloads**
- Simple APIs
- SQS producers or consumers
- Background workers with minimal orchestration needs

**Characteristics**
- No node management
- Fast operational setup
- AWS-native scaling and load balancing

---

### EKS (Kubernetes)

**Purpose**
- Run cloud-native workloads that benefit from Kubernetes primitives

**Typical workloads**
- Quarkus-based APIs
- Go-based async workers
- Services requiring advanced networking or observability

**Characteristics**
- Full Kubernetes API
- Advanced autoscaling
- Fine-grained traffic control
- Native support for Prometheus and OpenTelemetry

---

## Messaging & Eventing

### Amazon SQS (Core)

SQS is the primary asynchronous communication mechanism.

**Usage**
- Service-to-service async communication
- Decoupling ECS and EKS workloads
- Retry and failure isolation

**Patterns**
- At-least-once delivery
- Dead Letter Queues (DLQ)
- Idempotent consumers

---

### Amazon SNS / EventBridge

Used for **event fan-out and routing**.

**Usage**
- Domain events distribution
- Cross-service notifications
- Decoupled event consumers

**Benefits**
- No direct producer-to-consumer knowledge
- Easy extensibility

---

### Kafka (Optional / Comparative)

Kafka may be introduced **only for comparison purposes**.

**Goals**
- Compare managed streaming vs queue-based messaging
- Evaluate operational complexity
- Understand cost and maintenance trade-offs

Kafka is **not a core dependency** of the platform.

---

## Networking

- Single VPC
- Public subnets:
  - Application Load Balancer (ALB)
- Private subnets:
  - ECS tasks
  - EKS nodes
- No public IPs on workloads

**Traffic Flow**
1. External request → ALB
2. ALB routes to ECS or EKS
3. Services publish events to SQS/EventBridge
4. Consumers process events asynchronously

---

## Security Model

### Identity & Access
- IAM roles with least privilege
- IRSA (IAM Roles for Service Accounts) for EKS
- No static credentials inside containers

### Secrets
- AWS Secrets Manager
- AWS Systems Manager Parameter Store
- Injected dynamically at runtime

---

## Infrastructure as Code

All infrastructure is provisioned using **Terraform**.

**Principles**
- Single source of truth
- Modular design
- Environment isolation (`dev`, `staging`, `prod`)
- No manual changes via AWS Console

---

## Observability

Observability is treated as a first-class concern.

### Logging
- CloudWatch Logs for all services

### Metrics
- CloudWatch native metrics
- Prometheus for EKS workloads

### Tracing
- Optional distributed tracing via OpenTelemetry
- End-to-end visibility across HTTP and async flows

---

## Failure Handling

- Message retries handled by SQS
- DLQs for poison messages
- Stateless services for fast recovery
- Horizontal scaling instead of vertical tuning

---

## Design Trade-offs

This architecture intentionally prioritizes:
- Managed services over flexibility
- Reproducibility over manual tuning
- Platform consistency over stack uniformity

Detailed trade-offs are documented in `TRADEOFFS.md`.

---

## Summary

This architecture represents a **modern, cloud-native AWS platform**, designed to explore real-world trade-offs between compute models and messaging strategies without relying on traditional server management.

The focus is on **platform engineering concepts**, not infrastructure craftsmanship.
