variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project" {
  description = "The project name to use for unique resource naming"
  type        = string
}

variable "principal_arns" {
  description = "A list of principal ARNs allowed to assume the IAM role"
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

