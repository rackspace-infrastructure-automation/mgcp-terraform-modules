resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  provider = google-beta
  region   = var.region
  name     = var.gateway_name
  network  = var.network
}

resource "google_compute_router" "vpn-rtr" {
  name    = var.cloud_router_name
  region  = var.region
  network = var.network
  bgp {
    asn = var.bgp_asn
  }
}

resource "google_compute_external_vpn_gateway" "peer-gw" {
  provider        = google-beta
  name            = var.gateway_name
  redundancy_type = "TWO_IPS_REDUNDANCY"
  description     = "Peer VPN gateway"
  interface {
    id         = 0
    ip_address = var.peer_ips[0]
  }

  interface {
    id         = 1
    ip_address = var.peer_ips[1]
  }
}

## Tunnels

resource "google_compute_vpn_tunnel" "tunnel0" {
  provider                        = google-beta
  name                            = "${var.resource_prefix}-tunnels-0"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.self_link
  peer_external_gateway           = google_compute_external_vpn_gateway.peer-gw.self_link
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secrets[0]
  region                          = var.region
  router                          = google_compute_router.vpn-rtr.self_link
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  provider                        = google-beta
  name                            = "${var.resource_prefix}-tunnels-1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.self_link
  peer_external_gateway           = google_compute_external_vpn_gateway.peer-gw.self_link
  peer_external_gateway_interface = 1
  shared_secret                   = var.shared_secrets[1]
  region                          = var.region
  router                          = google_compute_router.vpn-rtr.self_link
  vpn_gateway_interface           = 1
}

## BGP Sessions

resource "google_compute_router_interface" "vpn-rtr-interface0" {
  provider   = google-beta
  name       = "${var.resource_prefix}-interface0"
  router     = google_compute_router.vpn-rtr.name
  ip_range   = var.bgp_cr_session_range[0]
  region     = var.region
  vpn_tunnel = google_compute_vpn_tunnel.tunnel0.name
}

resource "google_compute_router_interface" "vpn-rtr-interface1" {
  provider   = google-beta
  name       = "${var.resource_prefix}-interface1"
  router     = google_compute_router.vpn-rtr.name
  ip_range   = var.bgp_cr_session_range[1]
  region     = var.region
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "vpn-rtr-peer0" {
  provider                  = google-beta
  name                      = "${var.resource_prefix}-peer0"
  router                    = google_compute_router.vpn-rtr.name
  peer_ip_address           = var.peer_remote_session_range[0]
  peer_asn                  = var.peer_asn
  advertised_route_priority = var.advertised_route_priority[0]
  region                    = var.region
  interface                 = google_compute_router_interface.vpn-rtr-interface0.name
}

resource "google_compute_router_peer" "vpn-rtr-peer1" {
  provider                  = google-beta
  name                      = "${var.resource_prefix}-peer1"
  router                    = google_compute_router.vpn-rtr.name
  peer_ip_address           = var.peer_remote_session_range[1]
  peer_asn                  = var.peer_asn
  advertised_route_priority = var.advertised_route_priority[1]
  region                    = var.region
  interface                 = google_compute_router_interface.vpn-rtr-interface1.name
}
