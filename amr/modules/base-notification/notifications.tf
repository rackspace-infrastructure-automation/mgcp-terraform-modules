resource "google_monitoring_notification_channel" "notification_module" {
  display_name = var.display_name
  description  = var.description
  type         = var.type
  labels       = var.labels
}
