## Required variables

variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "project_name" {
  type = string
}

variable "number_of_relayers" {
  type = number
}

variable "app_container_port" {
  type = number
}

variable "app_image" {
  type = string
}

variable "app_tag" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "name_public_subnets" {
  type = string
}

variable "name_private_subnets" {
  type = string
}

## Non-required variables

variable "ecr_scan_on_push" {
  type    = bool
  default = false
}

variable "is_lb_internal" {
  type    = bool
  default = false
}

variable "lb_delete_protection" {
  type    = bool
  default = false
}

variable "tg_protocol" {
  type    = string
  default = "HTTP"
}

variable "tg_target_type" {
  type    = string
  default = "ip"
}

variable "tg_healthy_threshold" {
  type    = string
  default = "3"
}

variable "tg_interval" {
  type    = string
  default = "30"
}

variable "tg_matcher" {
  type    = string
  default = "200"
}

variable "tg_timeout" {
  type    = string
  default = "3"
}

variable "tg_health_check_path" {
  type    = string
  default = "/"
}

variable "app_memory_usage" {
  type    = number
  default = 512
}

variable "app_cpu_usage" {
  type    = number
  default = 256
}

variable "app_max_capacity" {
  type    = number
  default = 4
}

variable "log_retention_days" {
  type    = number
  default = 7
}
