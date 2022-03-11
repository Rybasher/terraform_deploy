provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_ecr_repository" "sec-test1" {
  name                 = "sec-test1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
