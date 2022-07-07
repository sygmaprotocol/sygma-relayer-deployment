variable "region" {
  default = "us-east-2"
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "elasticache_subnets" {
  type = list(string)
}