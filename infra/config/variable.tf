variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "codeland"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}
