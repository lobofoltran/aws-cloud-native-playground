# AWS Cloud-Native Playground

This project is a **cloud-native playground** built to explore and compare AWS managed services and modern application platforms, with a strong focus on **infrastructure as code, event-driven architecture, and container orchestration**.

The goal is not to optimize for a single “best” architecture, but to **intentionally use multiple AWS compute models** (ECS and EKS) to understand their trade-offs, operational characteristics, and ideal use cases in real-world cloud environments.

---

## Core Principles

- **Cloud-native by design**
- **No direct server management**
  - No SSH
  - No systemd
  - No manual provisioning
- **Fully managed AWS services**
- **Declarative infrastructure**
- **Reproducibility over craftsmanship**
- **Platform thinking over machine thinking**

> This project intentionally avoids direct server management and focuses exclusively on fully managed, cloud-native AWS services.

---

## High-Level Architecture

The platform runs multiple services using different compute paradigms, connected through managed messaging services.

### Compute
- **ECS Fargate**
  - Managed container workloads without Kubernetes
  - Ideal for simple APIs and background workers
- **EKS (Kubernetes)**
  - Cloud-native orchestration
  - Advanced networking, observability, and scaling

### Messaging
- **Amazon SQS**
  - Core asynchronous communication
  - Retry, DLQ, and backpressure handling
- **Amazon SNS / EventBridge**
  - Event fan-out and routing
- **Kafka (optional / comparative)**
  - Used only for learning and comparison, not as a mandatory dependency

### Infrastructure
- **Terraform** as the single source of truth
- Modular and environment-aware
- No click-ops

---

## Services Overview

| Service | Platform | Stack | Responsibility |
|------|--------|------|---------------|
| spring-api | ECS Fargate | Spring Boot | Stateless API and SQS producer |
| quarkus-service | EKS | Quarkus | Low-latency API and event publisher |
| go-worker | EKS | Go | Async event consumer and processing |

---

## Event-Driven Communication

The system is designed around **asynchronous messaging**:

- APIs publish events to **SQS**
- Workers consume events independently
- Failures are handled via retries and DLQs
- EventBridge/SNS can be used for fan-out scenarios

This design emphasizes:
- Loose coupling
- Horizontal scalability
- Failure isolation

---

## Infrastructure as Code

All infrastructure is provisioned using **Terraform**, including:

- VPC and networking
- ECS clusters and services
- EKS cluster and node groups
- IAM roles and IRSA
- SQS, SNS, and EventBridge
- Observability resources

There is **no manual configuration** performed outside Terraform.

---

## Observability

The platform includes observability as a first-class concern:

- **CloudWatch** for logs and metrics
- **Prometheus & Grafana** (EKS workloads)
- **Health checks and metrics endpoints**
- Optional distributed tracing with OpenTelemetry

---

## Environments

The infrastructure supports multiple isolated environments:

- `dev`
- `staging`
- `prod`

Each environment can have different sizing, scaling, and cost characteristics while sharing the same Terraform modules.

---

## Why ECS and EKS Together?

This project intentionally uses **both ECS and EKS** to demonstrate:

- When Kubernetes is powerful
- When Kubernetes is unnecessary
- How managed services reduce operational burden
- How platform engineers choose tools pragmatically

This is a **learning-driven architectural choice**, not an optimization exercise.

---

## What This Project Is Not

- A production system
- A cost-optimized reference
- A single-stack showcase
- A traditional server-based architecture

---

## Who This Project Is For

- Platform Engineers
- Cloud Engineers
- Backend Engineers exploring cloud-native systems
- Anyone interested in understanding **AWS compute trade-offs in practice**

---

## Roadmap

- [x] Terraform foundation
- [x] ECS service deployment
- [x] EKS service deployment
- [x] SQS-based communication
- [ ] EventBridge fan-out scenarios
- [ ] Optional Kafka comparison
- [ ] Advanced observability and tracing

---

## Final Notes

This project is intentionally opinionated toward **managed services, automation, and reproducibility**, reflecting how modern cloud platforms are designed and operated at scale.