variable "ext_port" {
  type = number
  default = 1880
}

variable "int_port" {
  type = number
  default = 1880
  validation {
    condition = var.int_port == 1880
    error_message = "Internal Nodered port must be 1880."
  }
}

variable "container_count" {
  type = number
  default = 1
}