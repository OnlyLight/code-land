variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "codeland"
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
}

variable "db_name" {
  default = "codeland"
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {
  sensitive = true
}
