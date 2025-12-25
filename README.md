# AWS Cloud-Native Playground

This project is a **cloud-native playground** built to explore, compare, and reason about **AWS managed services and modern application platforms**, with a strong focus on:

- **Infrastructure as Code**
- **Event-driven architecture**
- **Managed compute platforms**
- **Platform and cloud engineering practices**

The goal is not to optimize for a single “best” architecture, but to **intentionally combine multiple AWS compute and data models** to understand their trade-offs, operational characteristics, and real-world use cases.

---

## Core Principles

- **Cloud-native by design**
- **No direct server management**
  - No SSH
  - No systemd
  - No manual provisioning
- **Fully managed AWS services**
- **Declarative infrastructure**
- **Reproducibility over manual craftsmanship**
- **Platform thinking over machine thinking**
- **Clear separation of concerns**

> This project intentionally avoids server-level operations and focuses exclusively on **managed cloud primitives and platform abstractions**.

---

## High-Level Architecture

The platform runs multiple services using different compute paradigms, connected through **managed messaging and data services**, provisioned entirely via Terraform and operated through GitOps where applicable.

### Compute

- **ECS Fargate**
  - Managed container execution without Kubernetes
  - Ideal for stateless APIs and simple background processing

- **EKS (Kubernetes)**
  - Cloud-native orchestration
  - Used for workloads that benefit from Kubernetes-native patterns
  - GitOps-managed via ArgoCD

### Messaging & Events

- **Amazon SQS**
  - Core asynchronous communication mechanism
  - Retry, DLQ, and backpressure handling
- **Amazon SNS / EventBridge**
  - Event fan-out and routing
  - Decoupling producers from consumers
- **Kafka (optional / comparative)**
  - Used only for learning and comparison
  - Not a mandatory dependency

### Data

- **Amazon DynamoDB**
  - Idempotency keys
  - Distributed locks
  - Lightweight state and coordination
- **Amazon RDS (PostgreSQL)**
  - Transactional data
  - Strong consistency
  - Domain-oriented relational storage

### Infrastructure

- **Terraform** as the single source of truth
- Modular, environment-aware design
- No click-ops
- No manual drift correction

---

## Services Overview

| Service | Platform | Stack | Responsibility |
|------|--------|------|---------------|
| spring-api | ECS Fargate | Spring Boot | Stateless API, SQS producer, RDS access |
| quarkus-service | EKS | Quarkus | Low-latency API and event publisher |
| go-worker | EKS | Go | Asynchronous event consumer and processor |

---

## Event-Driven Communication

The system is designed around **asynchronous messaging**:

- APIs publish domain events to **SQS**
- Workers consume events independently
- Failures are handled via retries and DLQs
- EventBridge/SNS can be used for fan-out scenarios

This design emphasizes:

- Loose coupling
- Horizontal scalability
- Failure isolation
- Backpressure awareness

---

## Infrastructure as Code

All infrastructure is provisioned using **Terraform**, including:

- VPC, subnets, routing, NAT
- ECS clusters and services
- EKS cluster, node groups, and OIDC
- IAM roles and policies
- **IRSA (IAM Roles for Service Accounts)**
- SQS and DLQs
- DynamoDB tables
- RDS PostgreSQL instances
- Observability backends

There is **no manual configuration** performed outside Terraform.

---

## GitOps & Kubernetes Management

Kubernetes workloads are managed using **GitOps**:

- **ArgoCD** runs inside the EKS cluster
- Kubernetes manifests live under `k8s/`
- ArgoCD reconciles desired state from Git
- No manual `kubectl apply` in steady state

Terraform is responsible for **infrastructure**,  
ArgoCD is responsible for **Kubernetes state**.

---

## Observability

Observability is treated as a **first-class platform concern**:

- **CloudWatch**
  - Logs for ECS and infrastructure
- **Amazon Managed Prometheus (AMP)**
  - Metrics backend
- **Amazon Managed Grafana**
  - Dashboards and visualization
- **AWS Distro for OpenTelemetry (ADOT)**
  - Metrics collection in EKS via IRSA

This setup avoids self-hosted observability stacks while preserving **standardized instrumentation**.

---

## Environments

The infrastructure supports multiple isolated environments:

- `dev`
- `staging`
- `prod`

Each environment:
- Shares the same Terraform modules
- Can differ in size, scaling, and cost
- Is isolated at the infrastructure level

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
- A server-centric or VM-oriented architecture

---

## Who This Project Is For

- Platform Engineers
- Cloud Engineers
- Backend Engineers exploring cloud-native systems
- Anyone interested in **AWS compute, data, and orchestration trade-offs in practice**

---

## Roadmap

- [x] Terraform foundation
- [x] VPC, networking, and NAT
- [x] ECS service deployment
- [x] EKS cluster and workloads
- [x] SQS-based communication with DLQ
- [x] DynamoDB for idempotency and state
- [x] RDS PostgreSQL integration
- [x] IRSA and IAM hardening
- [x] Observability with AMP and Grafana
- [x] GitOps with ArgoCD
- [ ] EventBridge fan-out scenarios
- [ ] Optional Kafka comparison
- [ ] Distributed tracing with OpenTelemetry
- [ ] Multi-account setup

---

## Final Notes

This project reflects a **platform engineering mindset**, prioritizing:

- Managed services
- Clear boundaries
- Explicit trade-offs
- Automation and reproducibility

It is designed to mirror how **modern cloud platforms are built, operated, and evolved at scale**.
