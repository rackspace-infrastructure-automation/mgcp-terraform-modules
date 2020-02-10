
variable "network" {
  type = string
  description = "The name of the network to use"
}

variable "region" {
  type = string
  description ="The region where the gateway and tunnels are going to be created"
}


variable "bgp_asn" {
  type = number
  description = "ASN of the Cloud Router"
}

variable "peer_asn" {
  type = number
  description = "ASN of the peer VPN's router"
}

variable "peer_ips" {
  type = list
  description = "Peer Tunnel IPs"
}

variable "gateway_name" {
  type = string
  description = "The name of the VPN gateway being created"
}


variable "advertised_route_priority" {
  type = number
  default = 100
  description = "The priority of routes advertised to the BGP peers"
}

variable "bgp_cr_session_range" {
  type = list
  description = "Source IP and range of cloud router BGP session. A valid /30 subnet like 169.254.0.5/30"
}

variable "peer_remote_session_range" {
  type = list
  description = "Remote peer IP of cloud router BGP session. A valid ip in a /30 block like 169.254.0.6"
}

variable "cloud_router_name" {
  type = string
}

variable "resource_prefix" {
  type = string
  description = "Resource Prefix for the GCP Resources, allow multiple instanstiation of this module"
}

variable "shared_secrets" {
  type = list
  description = "IKEv2 Secret of the Tunnels"
}