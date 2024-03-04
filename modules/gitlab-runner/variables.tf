variable "project" {
  description = "Roject name"
  type = string
}

variable "remote" {
  description = "LXD remote"
  type = string
}

variable "suffix" {
  description = "Suffix"
  type = string
}

variable "image" {
  description = "Image"
  type = string
}

variable "ipv4_network" {
  description = "Network object"
  type = any
}
variable "ipv4_address" {
  description = "IPv4 address"
  type = string
}

variable "executor" {
  description = "Executor (shell or docker)"
  type        = string

  validation {
    condition     = can(regex("^(shell|docker)$", var.executor))
    error_message = "Must be shell or docker."
  }
}

variable "limits" {
  description = "Limits"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = 2
    memory = "4GB"
  }
}
