variable "project_name" {
  type    = string
  default = "cloud-native-playground"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
