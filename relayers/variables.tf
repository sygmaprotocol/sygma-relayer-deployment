## Required variables

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "project_name" {
  type    = string
  default = "relayers" // set project name, same as the vpc
}

variable "env" {
  type    = string
  default = "STAGE"
}
variable "app_container_port" {
  type    = number
  default = 9000
}

variable "efs_port" {
  type    = number
  default = 2049
}

variable "app_image" {
  type    = string
  default = "demo"  // set your variable
}

variable "app_tag" {
  type    = string
  default = "Demo" // set this tagging variable, 
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

variable "enable_ecr" {
  type    = bool
  default = false
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 0
}

variable "relayers" {
  type = number
  default = 3 //set number of relayers
}
