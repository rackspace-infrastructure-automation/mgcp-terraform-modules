resource "google_monitoring_notification_channel" "primary_email" {
  display_name = "primary-email"
  description  = "Primary email contact"
  type         = "email"
  labels = {
    email_address = var.primary_email
  }
  enabled = var.enabled
}