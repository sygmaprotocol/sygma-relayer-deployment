variable "region" {
  default = "us-east-2"
}

variable "project_name" {
  type    = string
  default = "relayers-choice"
}

variable "env" {
  type    = string
  default = "STAGE"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.100.0/24", "10.0.103.0/24", "10.0.105.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "database_subnets" {
  type    = list(string)
  default = ["10.0.32.0/24", "10.0.34.0/24"]
}

variable "elasticache_subnets" {
  type    = list(string)
  default = ["10.0.42.0/24", "10.0.52.0/24"]
}