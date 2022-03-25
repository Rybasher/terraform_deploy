provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "TerminationDate" = "Permanent",
      "Environment"     = "Development",
      "Team"            = "DevOps",
      "DeployedBy"      = "Terraform",
      "Application"     = "Indexer",
    }
  }
}