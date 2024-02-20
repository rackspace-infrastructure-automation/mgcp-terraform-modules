module "test-partner-interconnect-module" {
  source = "../."

  vlans          = ["test-vlan-a", "test-vlan-b"]
  asn            = "16550"
  advertise_mode = "CUSTOM"

  network = var.network
}