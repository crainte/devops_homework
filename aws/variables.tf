variable "region" {
  type    = string
  default = "us-east-2"
}

variable "profile" {
  type    = string
  default = "private"
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
}

variable "alarm_email" {
  type = string
}

variable "default_tags" {
  type    = map(any)
  default = { "Name" = "liquibase", "todo" = "Delete Me" }
}
