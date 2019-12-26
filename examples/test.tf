module "rs-sd-policy" {
  source         = "../rs-sd-policy"
  project_id     = "SOME_PROJECT"
  watchman_token = "SOME_TOKEN"
  enabled        = false
  rhel_disk_usage = {
    enabled              = true
    blk_dev_name         = "sda1"
    disk_threshold_bytes = 10737418240
  }

  debian_disk_usage = {
    enabled              = true
    blk_dev_name         = "root"
    disk_threshold_bytes = 10737418240
  }

  windows_disk_usage = {
    enabled              = true
    blk_dev_name         = "C:"
    disk_threshold_percentage = 90
  }

  memory_usage = {
    enabled       = true
    mem_threshold = 100
  }
  uptime_check = {
    enabled = true
  }
}

module "rs-base-firewall" {
  source       = "../rs-base-firewall"
  network_name = "default"
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
