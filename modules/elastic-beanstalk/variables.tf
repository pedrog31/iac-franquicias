variable "tags" {
  type = object({
    terraform   = bool,
    environment = string
  })
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_port" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}