variable "aws_region" {
  description = "AWS Region for the S3 and DynamoDB"
  default     = "us-east-1"
}

variable "bucket_state" {
  description = "S3 bucket for holding Terraform state files. Must be globally unique."
  type        = string
  default     = "aws-terraform-backend-states"
}

variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "aws-terraform-lock-states"
}