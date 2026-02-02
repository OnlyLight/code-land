variable "name" {
  type = string
}

variable "secret_string" {
  type      = string
  sensitive = true
}
