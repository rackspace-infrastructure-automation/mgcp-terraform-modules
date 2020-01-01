
variable "network" {
  type = string
}

variable "region" {
  type = string
}


variable "bgp_asn" {
  type = number
}

variable "peer_asn" {
  type = number
}

variable "peer_ips" {
  type = list
}

variable "gateway_name" {
  type = string
}


variable "advertised_route_priority" {
  type = number
  default = 100
}

variable "bgp_cr_session_range" {
  type = list
}

variable "peer_remote_session_range" {
  type = list
}

variable "cloud_router_name" {
  type = string
}


variable "resource_prefix" {
  type = string
}

variable "shared_secrets" {
  type = list
}