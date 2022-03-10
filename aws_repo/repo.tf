provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_ecr_repository" "test_repo" {
  name = "test-repo" # Naming my repository
}