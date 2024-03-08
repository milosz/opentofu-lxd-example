locals {
  cloud-init-config = file("modules/gitlab-runner/files/cloud-init.user-data.${var.executor}.cfg")
}

resource "lxd_instance" "gitlab-runner" {
  name    = "gitlab-runner-${var.executor}-${var.suffix}"
  project = var.project
  remote  = var.remote

  image     = var.image
  profiles  = ["${var.project}"]
  ephemeral = false
  type      = "virtual-machine"

  config = {
    "boot.autostart"       = true
    "cloud-init.user-data" = local.cloud-init-config
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype        = "bridged"
      parent         = var.ipv4_network.name
      "ipv4.address" = var.ipv4_address
    }
  }

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
      size = var.executor == "docker" ? "40GiB" : "20GB"
    }
  }

  limits = var.limits
}
