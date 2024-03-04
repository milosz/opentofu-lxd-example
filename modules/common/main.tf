resource "lxd_project" "project" {
  name        = var.project
  description = "Project managed using OpenTofu"
  remote      = var.remote
}

resource "lxd_cached_image" "images" {
  depends_on = [lxd_project.project]
  for_each   = var.cached_images

  remote = var.remote

  copy_aliases  = true
  source_remote = each.value.source_remote
  source_image  = each.value.source_image
  type          = each.value.type
}

resource "lxd_network" "network" {
  depends_on = [lxd_project.project]

  name    = var.project
  project = lxd_project.project.name
  remote  = var.remote

  type   = "bridge"
  config = var.network_config
}

resource "lxd_profile" "profile" {
  depends_on = [lxd_project.project, lxd_network.network]

  name    = var.project
  project = lxd_project.project.name
  remote  = var.remote

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = "${lxd_network.network.name}"
    }
  }

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
      size = "12GiB"
    }
  }
}
