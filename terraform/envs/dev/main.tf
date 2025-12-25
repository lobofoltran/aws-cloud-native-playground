terraform {
  backend "s3" {}
}

module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

module "orders_queue" {
  source = "../../modules/messaging/sqs"

  project_name = var.project_name
  environment  = var.environment
  queue_name   = "orders"

  visibility_timeout_seconds = 60
  max_receive_count          = 5
}

module "spring_api" {
  source = "../../modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

  container_name  = "spring-api"
  container_image = "${module.spring_api_ecr.repository_url}:latest"
  container_port  = 8080

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn

  queue_url = module.orders_queue.queue_url
}

module "spring_api_ecr" {
  source = "../../modules/ecr"

  project_name    = var.project_name
  environment     = var.environment
  repository_name = "spring-api"
}

module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
}

module "observability" {
  source = "../../modules/observability"

  project_name = var.project_name
  environment  = var.environment
}

module "idempotency_table" {
  source = "../../modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment

  table_name = "idempotency"

  hash_key = "pk"

  attributes = [
    {
      name = "pk"
      type = "S"
    }
  ]

  ttl_attribute = "expires_at"
}

module "postgres" {
  source = "../../modules/rds"

  project_name = var.project_name
  environment  = var.environment

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets

  db_name  = "orders"
  username = "app_user"
  password = var.db_password
}

resource "aws_security_group_rule" "ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"

  security_group_id        = module.postgres.security_group_id
  source_security_group_id = module.spring_api.security_group_id
}

module "dns" {
  source      = "../../modules/dns"
  domain_name = "lobofoltran.dev"
}

module "acm" {
  source      = "../../modules/acm"
  domain_name = "app.lobofoltran.dev"
  zone_id     = module.dns.zone_id
}

module "frontend_bucket" {
  source      = "../../modules/s3-static-site"
  bucket_name = "lobofoltran-dev-frontend"
}

module "cloudfront" {
  source           = "../../modules/cloudfront"
  domain_name      = "app.lobofoltran.dev"
  certificate_arn  = module.acm.certificate_arn
  origin_domain    = module.frontend_bucket.bucket_domain
  zone_id          = module.dns.zone_id
}

resource "aws_security_group_rule" "ecs_to_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = module.redis.security_group_id
  source_security_group_id = module.spring_api.security_group_id
}
