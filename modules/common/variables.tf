variable "project" {
  description = "Project name"
  type        = string
}

variable "remote" {
  description = "LXD remote"
  type = string
}

variable "network_config" {
  description = "Network settings"
  type        = map
}

variable "cached_images" {
  description = "Cached images"
  type = map(object({
    source_remote = string
    source_image  = string
    type          = string
  }))
  default = {
    ubuntu-jammy = {
      source_remote = "ubuntu"
      source_image  = "jammy"
      type          = "virtual-machine"
    },
  }
}

