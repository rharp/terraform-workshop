# Create a version requirement for the AWS provider for all future users
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_files = ["~/tf-shared/creds"] # My private credentials - to replicate checkout https://registry.terraform.io/providers/hashicorp/aws/latest/docs#provider-configuration
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "a" {
  bucket = "${var.env}-snyk-tf-workshop"

  tags = {
    Team = "SE"
  }
}

# Add Versioning to Original S3 Bucket
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.a.id # Points to original bucket id to apply config
  versioning_configuration {
    status = "Enabled"
  }
}

module "iam_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
  version = "~> 4"

  account_alias = "snyk"

  minimum_password_length = 37
  require_numbers         = false
}
