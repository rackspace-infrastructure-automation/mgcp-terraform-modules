
variable "network" {
  type        = string
  description = "The name of the network to use"
}

variable "region" {
  type        = string
  description = "The region where the gateway and tunnels are going to be created"
}


variable "bgp_asn" {
  type        = number
  description = "ASN of the Cloud Router"
}

variable "bgp_advertise_mode" {
  type        = string
  description = "Advertise mode of the Cloud Router"
  default     = null
}

variable "bgp_range_desc" {
  type        = string
  description = "Advertise IP Ranges description of the Cloud Router for BGP sessions"
  default     = null
}

variable "bgp_range" {
  type        = string
  description = "Advertise IP Ranges on the Cloud Router for BGP sessions"
  default     = null
}

variable "bgp_advertised_groups" {
  type        = list(any)
  description = "Advertise subnets on the Cloud Router for BGP sessions"
  default     = null
}

variable "peer_asn" {
  type        = number
  description = "ASN of the peer VPN's router"
}

variable "peer_ips" {
  type        = list(any)
  description = "Peer Tunnel IPs"
}

variable "gateway_name" {
  type        = string
  description = "The name of the VPN gateway being created"
}


variable "advertised_route_priority" {
  type        = list(number)
  description = "The priority of routes advertised to the BGP peers"
  default     = [0, 0]
}

variable "bgp_cr_session_range" {
  type        = list(any)
  description = "Source IP and range of cloud router BGP session. A valid /30 subnet like 169.254.0.5/30"
}

variable "peer_remote_session_range" {
  type        = list(any)
  description = "Remote peer IP of cloud router BGP session. A valid ip in a /30 block like 169.254.0.6"
}

variable "cloud_router_name" {
  type = string
}

variable "resource_prefix" {
  type        = string
  description = "Resource Prefix for the GCP Resources, allow multiple instanstiation of this module"
}

variable "shared_secrets" {
  type        = list(any)
  description = "IKEv2 Secret of the Tunnels"
}