# module "rs-sd-policy" {
#   source         = "../rs-sd-policy"
#   project_id     = "mgcp-kubetetris-next"
#   watchman_token = "SOME_TOKEN"
#   enabled        = false
#   rhel_disk_usage = {
#     enabled              = true
#     blk_dev_name         = "sda1"
#     disk_threshold_bytes = 10737418240
#   }

#   debian_disk_usage = {
#     enabled              = true
#     blk_dev_name         = "root"
#     disk_threshold_bytes = 10737418240
#   }

#   windows_disk_usage = {
#     enabled              = true
#     blk_dev_name         = "C:"
#     disk_threshold_percentage = 90
#   }

#   memory_usage = {
#     enabled       = true
#     mem_threshold = 100
#   }
#   uptime_check = {
#     enabled = true
#   }
# }

module "rs-base-firewall" {
  source       = "../rs-base-firewall"
  network_name = "default"
}

module "ha-vpn" {
  source = "../ha-vpn"

  network                   = "default"
  region                    = "europe-west2"
  cloud_router_name         = "vpn-rtr"
  gateway_name              = "some-gateway"
  resource_prefix           = "some-prefix"
  shared_secrets            = ["blah", "bleh"]
  peer_ips                  = ["1.1.1.1", "2.2.2.2"]
  peer_asn                  = 65002
  peer_remote_session_range = ["169.254.0.6", "169.254.1.6"]
  bgp_asn                   = 65001
  bgp_cr_session_range      = ["169.254.0.5/30", "169.254.1.5/30"]
}


provider "google" {
  project = "SOME_PROJECT"
  region  = "europe-west2"
  zone    = "europe-west2-b"
  version = "~> 2.20.0"
}

provider "google-beta" {
  project = "SOME_PROJECT"
  region  = "europe-west2"
  zone    = "europe-west2-b"
  version = "~> 2.20.0"
}
