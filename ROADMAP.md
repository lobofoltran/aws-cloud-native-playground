# Roadmap

This roadmap defines the **planned evolution** of the AWS Cloud-Native Playground.

The goal is to incrementally explore **AWS managed services and cloud-native patterns** while keeping the project controlled, reproducible, and learning-focused.

This is not a feature roadmap — it is a **platform learning roadmap**.

---

## Phase 0 — Foundation (Project Bootstrap)

**Goal:** Establish a clean, opinionated foundation.

- [x] Define project scope and principles
- [x] Create repository structure
- [x] Write core documentation
  - README.md
  - ARCHITECTURE.md
  - TRADEOFFS.md
  - ROADMAP.md
- [ ] Add high-level architecture diagram

**Exit Criteria**
- Repository structure finalized
- Architectural intent clearly documented

---

## Phase 1 — Infrastructure Core (Terraform)

**Goal:** Provision the core cloud-native infrastructure using Terraform only.

- [ ] Configure Terraform backend (S3 + DynamoDB)
- [ ] Create VPC with public and private subnets
- [ ] Provision Application Load Balancer (ALB)
- [ ] Create IAM base roles and policies
- [ ] Define environment structure (`dev`, `staging`, `prod`)

**Exit Criteria**
- Infrastructure can be fully created and destroyed via Terraform
- No manual AWS Console configuration

---

## Phase 2 — ECS Workload

**Goal:** Deploy a fully managed container workload using ECS Fargate.

- [ ] Create ECS cluster (Fargate)
- [ ] Define task definition for Spring Boot API
- [ ] Deploy ECS service behind ALB
- [ ] Enable CloudWatch logging
- [ ] Add basic health checks

**Exit Criteria**
- ECS service reachable via ALB
- Zero server or node management

---

## Phase 3 — EKS Cluster

**Goal:** Introduce Kubernetes as a cloud-native orchestration layer.

- [ ] Provision EKS cluster with Terraform
- [ ] Configure managed node groups
- [ ] Install core add-ons (CNI, CoreDNS, kube-proxy)
- [ ] Configure IAM Roles for Service Accounts (IRSA)
- [ ] Deploy Ingress Controller

**Exit Criteria**
- EKS cluster operational
- Kubernetes workloads deployable via declarative manifests

---

## Phase 4 — EKS Workloads

**Goal:** Run cloud-native services on Kubernetes.

- [ ] Deploy Quarkus service on EKS
- [ ] Deploy Go worker on EKS
- [ ] Expose services via Ingress
- [ ] Configure health and readiness probes
- [ ] Enable autoscaling (HPA)

**Exit Criteria**
- Multiple services running on EKS
- Independent scaling per service

---

## Phase 5 — Event-Driven Communication (Core)

**Goal:** Introduce asynchronous communication between services.

- [ ] Provision SQS queues via Terraform
- [ ] Configure DLQs
- [ ] Publish events from ECS services
- [ ] Consume events from EKS workers
- [ ] Implement idempotent consumers

**Exit Criteria**
- ECS ↔ EKS communication via SQS
- Failure handling via retries and DLQs

---

## Phase 6 — Event Routing & Fan-out

**Goal:** Decouple producers and consumers further.

- [ ] Introduce SNS or EventBridge
- [ ] Implement event fan-out
- [ ] Add multiple consumers for a single event
- [ ] Document event contracts

**Exit Criteria**
- No direct producer-to-consumer coupling
- Event routing handled by managed services

---

## Phase 7 — Observability

**Goal:** Treat observability as a first-class concern.

- [ ] Standardize structured logging
- [ ] Collect metrics from ECS and EKS
- [ ] Deploy Prometheus and Grafana (EKS)
- [ ] Visualize queue depth and processing latency
- [ ] Optional distributed tracing with OpenTelemetry

**Exit Criteria**
- End-to-end visibility across services
- Metrics and logs usable for debugging

---

## Phase 8 — Comparative Messaging (Optional)

**Goal:** Explore streaming-based messaging trade-offs.

- [ ] Provision Kafka (MSK or EKS-based)
- [ ] Publish and consume sample events
- [ ] Compare Kafka vs SQS behavior
- [ ] Document operational and cost differences

**Exit Criteria**
- Kafka used purely for comparison
- Clear documentation of trade-offs

---

## Phase 9 — Hardening & Polish

**Goal:** Improve platform quality and documentation.

- [ ] Add Network Policies (EKS)
- [ ] Improve IAM least-privilege policies
- [ ] Add basic cost awareness notes
- [ ] Finalize diagrams
- [ ] Review and refine documentation

**Exit Criteria**
- Platform reflects real-world cloud-native practices
- Documentation matches implementation

---

## Phase 10 — Portfolio Readiness

**Goal:** Prepare the project for public sharing.

- [ ] Clean commit history
- [ ] Ensure all Terraform plans are reproducible
- [ ] Add screenshots and diagrams
- [ ] Review README for clarity
- [ ] Publish project in personal portfolio

**Exit Criteria**
- Project communicates platform engineering maturity
- Ready for technical review by peers or recruiters

---

## Final Note

This roadmap is intentionally **linear and bounded**.

The project should stop once:
- ECS workloads work
- EKS workloads work
- Event-driven communication is established
- Trade-offs are documented

Anything beyond that is **optional exploration**, not a requirement.
