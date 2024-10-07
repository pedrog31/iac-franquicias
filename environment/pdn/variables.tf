variable "tags" {
  type = object({
    terraform   = bool,
    environment = string
  })
}
