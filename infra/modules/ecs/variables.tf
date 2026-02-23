variable "image" {}
variable "family" {}
variable "container_name" {}
variable "secret_arn" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {}
variable "db_host" {}
variable "db_name" {}
# variable "db_secrets" {
#   sensitive = true
# }
variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}
variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "tags" {
  type    = map(string)
  default = {}
}
