terraform {
  required_version = ">= 1.8.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.77.0"
      configuration_aliases = [aws.target]
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}