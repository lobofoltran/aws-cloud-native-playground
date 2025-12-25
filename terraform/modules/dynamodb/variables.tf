variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "table_name" {
  type = string
}

variable "hash_key" {
  type = string
}

variable "range_key" {
  type    = string
  default = null
}

variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "attributes" {
  description = "List of attribute definitions"
  type = list(object({
    name = string
    type = string
  }))
}

variable "ttl_attribute" {
  type    = string
  default = null
}

variable "point_in_time_recovery" {
  type    = bool
