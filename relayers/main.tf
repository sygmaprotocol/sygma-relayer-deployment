terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
  # backend "remote" {
  #   organization = "ChainSafe"

  #   workspaces {
  #     prefix = "chainbridge-relayer-"
  #   }
  # }
}

// Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = "default"
  default_tags {
    tags = {
      Env       = var.env
      Project   = var.project_name
      Terraform = "true"

    }
  }
}