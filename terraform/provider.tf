provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "TerminationDate" = "Permanent",
      "Team"            = "DevOps",
      "DeployedBy"      = "Terraform",
    }
  }
}

