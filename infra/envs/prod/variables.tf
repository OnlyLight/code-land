variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "codeland"
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "codeland-project:ba75ec4"
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

variable "github_org" {
  description = "GitHub organization or username"
}

variable "github_repo" {
  description = "GitHub repository name"
}
