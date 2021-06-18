## Alert Policy Module
# Generic Policy

resource "google_monitoring_alert_policy" "alert_policy_module" {
  display_name = var.policy_display_name
  combiner     = var.combiner
  enabled      = var.enabled
  conditions {
    display_name = var.condition_display_name
    condition_threshold {
      filter     = var.condition_filter
      duration   = var.condition_duration
      comparison = var.comparison
      aggregations {
        alignment_period     = var.alignment_period
        per_series_aligner   = var.per_series_aligner
        cross_series_reducer = var.cross_series_reducer
        group_by_fields      = var.group_by_fields
      }
      threshold_value = var.threshold
      trigger {
        count = var.trigger_count
      }
    }
  }
  documentation {
    mime_type = var.mime_type
    content   = var.runbook_content
  }
  notification_channels = var.notification_channels
}
