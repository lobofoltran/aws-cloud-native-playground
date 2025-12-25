# AWS Cloud-Native Playground

This project is a **cloud-native playground** designed to explore, compare, and reason about **AWS managed services and modern application platforms**, with a strong focus on:

- Infrastructure as Code
- Event-driven architecture
- Managed compute platforms
- Platform and cloud engineering practices
- End-to-end system design

The goal is **not** to optimize for a single “best” architecture, but to intentionally combine multiple AWS services and execution models in order to understand their **trade-offs, operational characteristics, and real-world applicability**.

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

> This project intentionally avoids server-level operations and focuses exclusively on managed cloud primitives and platform abstractions.

---

## High-Level Architecture

The platform is composed of multiple services running on different AWS compute paradigms, connected through managed messaging and data services, and exposed via a static frontend served at the edge.

```
Frontend (S3 + CloudFront)
|
v
APIs (ECS / EKS)
|
v
Messaging (SQS / EventBridge)
|
v
Workers (EKS)
|
v
Data (RDS / DynamoDB)
```


All infrastructure is provisioned via Terraform, and Kubernetes workloads are managed using GitOps.

---

## Compute Platforms

### ECS Fargate
- Fully managed container execution
- No cluster or node management
- Ideal for stateless APIs and simple background services

### EKS (Kubernetes)
- Cloud-native orchestration
- Used for workloads that benefit from Kubernetes primitives
- Managed declaratively and reconciled via GitOps (ArgoCD)

The project intentionally uses **both ECS and EKS** to demonstrate **when Kubernetes is valuable and when it is unnecessary**.

---

## Messaging & Eventing

- **Amazon SQS**
  - Primary asynchronous communication channel
  - Retries, DLQs, and backpressure handling
- **Amazon SNS / EventBridge**
  - Event fan-out and routing
  - Loose coupling between producers and consumers
- **Kafka (optional / comparative)**
  - Included only for learning and comparison
  - Not a mandatory dependency

This architecture emphasizes:
- Loose coupling
- Failure isolation
- Horizontal scalability
- Event-driven system design

---

## Data Layer

### Amazon DynamoDB
- Idempotency keys
- Lightweight state
- Distributed locks and coordination
- Event-processing support

### Amazon RDS (PostgreSQL)
- Transactional data
- Strong consistency
- Domain-oriented relational storage
- Private, VPC-isolated access

DynamoDB and RDS are used **together**, each for what they do best.

---

## Frontend & Edge

The platform includes a static frontend deployed using:

- **Amazon S3** (static hosting)
- **Amazon CloudFront** (CDN)
- **AWS ACM** (TLS)
- **Amazon Route 53** (DNS)

Characteristics:
- Fully managed
- HTTPS enforced
- No custom backend
- Deployed independently from backend services

The frontend interacts with ECS and EKS APIs and provides visibility into asynchronous workflows.

---

## Infrastructure as Code

All infrastructure is provisioned using **Terraform**, including:

- VPC, subnets, routing, and NAT
- ECS clusters and services
- EKS cluster, node groups, and OIDC
- IAM roles and policies
- **IRSA (IAM Roles for Service Accounts)**
- SQS queues and DLQs
- EventBridge rules
- DynamoDB tables
- RDS PostgreSQL instances
- Frontend infrastructure (S3, CloudFront, ACM, Route 53)
- Observability backends

There is **no manual configuration** performed outside Terraform.

---

## GitOps & Kubernetes Management

Kubernetes workloads are managed using **GitOps**:

- **ArgoCD** runs inside the EKS cluster
- All Kubernetes manifests live under `k8s/`
- ArgoCD continuously reconciles desired state from Git
- No manual `kubectl apply` in steady state

Terraform is responsible for **infrastructure**,  
ArgoCD is responsible for **Kubernetes state**.

---

## Observability

Observability is treated as a **first-class platform concern**:

- **Amazon CloudWatch**
  - Logs and metrics for ECS and infrastructure
- **Amazon Managed Prometheus (AMP)**
  - Centralized metrics backend
- **Amazon Managed Grafana**
  - Dashboards and visualization
- **AWS Distro for OpenTelemetry (ADOT)**
  - Metrics collection in EKS via IRSA

This setup avoids self-hosted observability stacks while preserving standardized instrumentation.

---

## Environments

The project supports multiple isolated environments:

- `dev`
- `staging`
- `prod`

Each environment:
- Uses the same Terraform modules
- Is fully isolated
- Can differ in size, scaling, and cost characteristics

---

## Services Overview

| Service           | Platform      | Stack        | Responsibility |
|------------------|---------------|--------------|----------------|
| spring-api        | ECS Fargate   | Spring Boot  | Stateless API, SQS producer, RDS access |
| quarkus-service   | EKS           | Quarkus      | Low-latency API and event publisher |
| go-worker         | EKS           | Go           | Asynchronous event consumer and processor |
| frontend          | S3 + CDN      | React / Next | User interaction and workflow visibility |

---

## What This Project Is Not

- A production system
- A cost-optimized reference
- A single-stack showcase
- A server-centric or VM-oriented architecture

This project prioritizes **learning, trade-off analysis, and architectural clarity**.

---

## Who This Project Is For

- Platform Engineers
- Cloud Engineers
- Backend Engineers exploring cloud-native systems
- Engineers interested in AWS compute, data, and orchestration trade-offs

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
- [x] Frontend with S3, CloudFront, TLS, and DNS
- [ ] EventBridge fan-out scenarios
- [ ] Lambda for event glue
- [ ] Distributed tracing with OpenTelemetry
- [ ] Multi-account AWS setup

---

## Final Notes

This project reflects a **platform engineering mindset**, prioritizing:

- Managed services over infrastructure ownership
- Explicit trade-offs over “one-size-fits-all” solutions
- Automation, security, and reproducibility
- End-to-end system design

It is designed to mirror how **modern cloud platforms are built, operated, and evolved at scale**.
