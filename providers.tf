provider "lxd" {
  generate_client_certificates = false
  accept_remote_certificate    = true

  remote {
    name    = "manticore"
    scheme  = "https"
    address = "192.168.68.61"
    port    = "8443"
  }
  remote {
    name    = "basilisk"
    scheme  = "https"
    address = "192.168.68.62"
    port    = "8443"
  }
}
