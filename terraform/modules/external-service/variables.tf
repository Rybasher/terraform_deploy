variable "name" {
  type = string
}

variable "td-env" {
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
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

variable "service-count" {
  type = number
}

variable "execution-role" {
  type = string
}

variable "cert_activated" {
  description = "If certificate is activated "
  type = string
  default = "ISSUED"
}