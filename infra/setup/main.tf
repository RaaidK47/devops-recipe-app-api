terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.0"
    }
  }
  backend "s3" {
    bucket         = "devops-recipe-app-tf-state-mrk" # Replace with your actual bucket
    key            = "tf-state-setup"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "devops-recipe-app-api-tf-lock" # DynamoDB Table for State Locking
  }
}

provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = {
      environment = terraform.workspace
      project     = var.project
      contact     = var.contact
      managed_by  = "Terraform/setup"
    }
  }
}
