resource "google_monitoring_notification_channel" "rackspace_normal" {
  display_name = "rackspace-normal"
  description  = "Rackspace normal severity notification channel"
  type         = "webhook_tokenauth"
  labels = {
    url = "https://watchman.api.manage.rackspace.com/v0/gcpProjects/${var.project_id}/incident?source=stackdriver&secret=${var.watchman_token}&severity=normal"
  }
  enabled = var.enabled
}