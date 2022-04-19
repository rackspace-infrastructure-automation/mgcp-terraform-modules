module "rackspace_low" {
  source       = "./modules/base-notification"
  display_name = "rackspace-low"
  description  = "Rackspace low severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=low"
  }
}

module "rackspace_normal" {
  source       = "./modules/base-notification"
  display_name = "rackspace-normal"
  description  = "Rackspace normal severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=normal"
  }
}

module "rackspace_high" {
  source       = "./modules/base-notification"
  display_name = "rackspace-high"
  description  = "Rackspace high severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=high"
  }
}

module "rackspace_urgent" {
  source       = "./modules/base-notification"
  display_name = "rackspace-urgent"
  description  = "Rackspace urgent severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=urgent"
  }
}

module "rackspace_emergency" {
  source       = "./modules/base-notification"
  display_name = "rackspace-emergency"
  description  = "Rackspace emergency severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=emergency"
  }
}
