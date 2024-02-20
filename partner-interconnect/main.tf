resource "google_compute_interconnect_attachment" "attachment" {
  count = length(var.vlans)

  name   = var.vlans[count.index]
  type   = "PARTNER"
  router = element(google_compute_router.router.*.self_link, count.index)

  lifecycle {
    ignore_changes = ["vlan_tag8021q"]
  }
}

resource "google_compute_router" "router" {
  count = length(var.vlans)

  name    = "${var.vlans[count.index]}-router"
  network = var.network

  bgp {
    asn               = var.asn
    advertise_mode    = var.advertise_mode
    advertised_groups = var.advertise_mode == "CUSTOM" ? ["ALL_SUBNETS"] : null
  }
}
