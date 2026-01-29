variable "cluster_name" {}
variable "image" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {}
variable "db_host" {}
variable "db_name" {}
variable "db_secret_arn" {}
