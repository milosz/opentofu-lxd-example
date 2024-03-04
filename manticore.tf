module "common-manticore-managed" {
  source  = "./modules/common"
  project = "managed"
  remote  = "manticore"

  network_config = {
    "ipv4.address" = "10.20.0.1/24"
    "ipv4.nat"     = true
    "ipv6.address" = "none"
  }
}

module "common-manticore-unmanaged" {
  source  = "./modules/common"
  project = "unmanaged"
  remote  = "manticore"

  network_config = {
    "ipv4.address" = "10.30.0.1/24"
    "ipv4.nat"     = true
    "ipv6.address" = "none"
  }

  cached_images = {}
}

module "gitlab-runner-manticore-shell" {
  depends_on   = [module.common-manticore-managed]
  suffix       = "0"
  source       = "./modules/gitlab-runner"
  project      = "managed"
  remote       = "manticore"
  executor     = "shell"
  image        = module.common-manticore-managed.cached_images.ubuntu-jammy.fingerprint
  ipv4_network = module.common-manticore-managed.network
  ipv4_address = "10.20.0.200"
  limits = {
    "cpu"    = "2"
    "memory" = "2GB"
  }
}

module "gitlab-runner-manticore-docker" {
  depends_on   = [module.common-manticore-managed]
  suffix       = "1"
  source       = "./modules/gitlab-runner"
  project      = "managed"
  remote       = "manticore"
  executor     = "docker"
  image        = module.common-manticore-managed.cached_images.ubuntu-jammy.fingerprint
  ipv4_network = module.common-manticore-managed.network
  ipv4_address = "10.20.0.201"
}


locals {
  vm-cloud-init-config = file("files/cloud-init.user-data.cfg")
}


resource "lxd_instance" "vm" {
  count = 8
  name    = "beastie-${count.index}"
  project = "unmanaged"
  remote  = "manticore"

  image        = module.common-manticore-managed.cached_images.ubuntu-jammy.fingerprint
  profiles  = ["unmanaged"]
  ephemeral = false
  type      = "virtual-machine"

  running = false

  config = {
    "boot.autostart"       = true
    "cloud-init.user-data" = local.vm-cloud-init-config
  }

  limits = {
    "cpu"    = "2"
    "memory" = "2GB"
  }
}
