terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "codeland-s3-backend"
    key            = "envs/prod/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "codeland-s3-backend"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
