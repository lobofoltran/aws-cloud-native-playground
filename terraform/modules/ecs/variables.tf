variable "project_name" { type = string }
variable "environment"  { type = string }

variable "vpc_id"            { type = string }
variable "public_subnets"    { type = list(string) }
variable "private_subnets"   { type = list(string) }

variable "container_name" { type = string }
variable "container_image" { type = string }
variable "container_port" { type = number }

variable "cpu"    { type = number default = 256 }
variable "memory" { type = number default = 512 }

variable "desired_count" { type = number default = 1 }

variable "ecs_task_execution_role_arn" { type = string }
variable "ecs_task_role_arn"           { type = string }

variable "queue_url" { type = string }
