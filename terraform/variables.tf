variable "state_bucket" {
  description = "S3 bucket for holding Terraform state files. Must be globally unique."
  type        = string
  default     = "aws-kirill-states-bucket"
}

variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "kirill-dynamodb"
}

variable "td-environment" {
}
