terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0" # Ensures compatibility with AWS provider 5.x versions
    }
  }
}

provider "aws" {
  region = "us-east-1"
}