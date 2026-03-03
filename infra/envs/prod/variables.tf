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
  type      = string
  sensitive = true

  validation {
    condition     = length(trimspace(var.db_password)) > 0
    error_message = "db_password must be set (non-empty). In CI, pass it via TF_VAR_db_password (GitHub Secrets/Environments)."
  }
}
