terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }
}

// Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Env       = var.env
      Project   = var.project_name
      Terraform = "true"

    }
  }
}
