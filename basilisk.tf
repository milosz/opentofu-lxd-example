module "common-basilisk-managed" {
  source  = "./modules/common"
  project = "managed"
  remote  = "basilisk"

  network_config = {
    "ipv4.address" = "10.20.0.1/24"
    "ipv4.nat"     = true
    "ipv6.address" = "none"
  }
}

module "common-basilisk-unmanaged" {
  source  = "./modules/common"
  project = "unmanaged"
  remote  = "basilisk"

  network_config = {
    "ipv4.address" = "10.30.0.1/24"
    "ipv4.nat"     = true
    "ipv6.address" = "none"
  }

  cached_images = {}
}

module "gitlab-runner-basilisk-shell" {
  depends_on   = [module.common-basilisk-managed]
  suffix       = "0"
  source       = "./modules/gitlab-runner"
  project      = "managed"
  remote       = "basilisk"
  executor     = "shell"
  image        = module.common-basilisk-managed.cached_images.ubuntu-jammy.fingerprint
  ipv4_network = module.common-basilisk-managed.network
  ipv4_address = "10.20.0.200"
  limits = {
    "cpu"    = "2"
    "memory" = "2GB"
  }
}

module "gitlab-runner-basilisk-docker" {
  depends_on   = [module.common-basilisk-managed]
  suffix       = "1"
  source       = "./modules/gitlab-runner"
  project      = "managed"
  remote       = "basilisk"
  executor     = "docker"
  image        = module.common-basilisk-managed.cached_images.ubuntu-jammy.fingerprint
  ipv4_network = module.common-basilisk-managed.network
  ipv4_address = "10.20.0.201"
}


resource "lxd_instance" "basilisk-vm-small" {
  count = 3
  name    = "abnomination-${count.index}"
  project = "unmanaged"
  remote  = "basilisk"

  image        = module.common-manticore-managed.cached_images.ubuntu-jammy.fingerprint
  profiles  = ["unmanaged"]
  ephemeral = false
  type      = "virtual-machine"

  running = false

  config = {
    "boot.autostart"       = true
  }

  limits = {
    "cpu"    = "3"
    "memory" = "4GB"
  }
}

resource "lxd_instance" "basilisk-vm-medium" {
  count = 2
  name    = "daemon-${count.index}"
  project = "unmanaged"
  remote  = "basilisk"

  image        = module.common-manticore-managed.cached_images.ubuntu-jammy.fingerprint
  profiles  = ["unmanaged"]
  ephemeral = false
  type      = "virtual-machine"

  running = false

  config = {
    "boot.autostart"       = true
  }

  limits = {
    "cpu"    = "4"
    "memory" = "6GB"
  }
}

resource "lxd_instance" "basilisk-vm-regular" {
  count = 1
  name    = "nightmare-${count.index}"
  project = "unmanaged"
  remote  = "basilisk"

  image        = module.common-manticore-managed.cached_images.ubuntu-jammy.fingerprint
  profiles  = ["unmanaged"]
  ephemeral = false
  type      = "virtual-machine"

  running = false

  config = {
    "boot.autostart"       = true
  }

  limits = {
    "cpu"    = "4"
    "memory" = "8GB"
  }
}
