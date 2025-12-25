variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "broker_instance_type" {
  type    = string
  default = "kafka.t3.small"
}

variable "kafka_version" {
  type    = string
  default = "3.6.0"
}
