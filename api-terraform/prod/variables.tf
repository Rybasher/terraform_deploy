variable "aws_region" {
  description = "AWS Region for the S3 and DynamoDB"
  default     = "us-east-1"
}

variable "state_bucket" {
  description = "S3 bucket for holding Terraform state files. Must be globally unique."
  type        = string
  default     = "aws-terraform-prod-states-backend"
}

variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "aws-terraform-prod-states-lock"
}

variable "cloudwatch_group" {
  description = "CloudWatch group name."
  type = string
  default = "ProdCloudWatchAPI"
}

variable "db_identifier" {
  description = "RDS database identifier"
  type = string
  default = "dbapiprod"
}

variable "load_balancer" {
  description = "Name of load balancer"
  type = string
  default = "ProdLoadBalancerAPI"
}

variable "load_balancer_security_group" {
  description = "Name of security group for load balancer"
  type = string
  default = "ProdSecurityGroupAPI"
}


variable "target_group"{
  description = "Name of target group"
  type = string
  default = "ProdTargetGroupAPI"
}

variable "image-repo"{
  description = "Name of ecr repo"
  type = string
  default = "prod-repo-indexer"
}

variable "cluster"{
  description = "Name of ecs cluster"
  type = string
  default = "ProdClusterAPI"
}

