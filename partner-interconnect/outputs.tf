
output "cloud_router_name" {
  value       = google_compute_router.router.*.name
  description = "Cloud router name"
}

output "bgp_config" {
  value       = google_compute_router.router.*.bgp
  description = "Cloud router BGP config"
}

output "interconnect_vlan_name" {
  value       = google_compute_interconnect_attachment.attachment.*.name
  description = "The VLAN attachment name"
}

output "interconnect_pairing_key" {
  value       = google_compute_interconnect_attachment.attachment.*.pairing_key
  description = "The identifier of a PARTNER attachment used to initiate provisioning with selected partner"
}

