variable "name" {
  type = string
}


variable "td-env" {
}

variable "container-port" {
  type = number
}

variable "container-memory" {
  type = number
}

variable "container-cpu" {
  type = number
}

variable "task_name" {
  type = string
}

variable "cloudwatch_schedule_expression" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets where the job will be run"
}