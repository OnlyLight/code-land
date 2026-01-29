variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "codeland"
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

