
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version="~> 5.0" }
  }
}
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
# CI Role (create): arn:aws:iam::764265373335:role/github-oidc-deploy
