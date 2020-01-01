output "gateway_self_link" {
  description = "The self-link of the Gateway"
  value       = google_compute_ha_vpn_gateway.ha_gateway.self_link
}

output "gateway_ips" {
  description = "The VPN Gateway Public IP"
  value       = google_compute_ha_vpn_gateway.ha_gateway.vpn_interfaces
}