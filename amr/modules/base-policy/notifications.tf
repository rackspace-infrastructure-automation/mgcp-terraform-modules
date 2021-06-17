resource "google_monitoring_notification_channel" "rackspace_low" {
  display_name = "rackspace-low"
  description  = "Rackspace low severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=low"
  }
}

resource "google_monitoring_notification_channel" "rackspace_normal" {
  display_name = "rackspace-normal"
  description  = "Rackspace normal severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=normal"
  }
}

resource "google_monitoring_notification_channel" "rackspace_high" {
  display_name = "rackspace-high"
  description  = "Rackspace high severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=high"
  }
}

resource "google_monitoring_notification_channel" "rackspace_urgent" {
  display_name = "rackspace-urgent"
  description  = "Rackspace urgent severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=urgent"
  }
}

resource "google_monitoring_notification_channel" "rackspace_emergency" {
  display_name = "rackspace-emergency"
  description  = "Rackspace emergency severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=emergency"
  }
}