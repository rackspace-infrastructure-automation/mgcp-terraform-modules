data "google_compute_zones" "available_zones" {
  region = var.region
}

module "ssm-policy" {
  for_each = toset(data.google_compute_zones.available_zones.names)
  source   = "./modules"
  exclusion_label = {
    key   = "install-ssm-agent"
    value = "false"
  }
  zone = each.value
  name = "ssm-policy-${each.value}"
}