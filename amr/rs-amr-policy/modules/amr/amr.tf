## Alert Policy Module
# Generic Policy

resource "google_monitoring_alert_policy" "alert_policy_module" {
  display_name = var.policy_display_name
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = var.condition_display_name
    condition_threshold {
      filter     = var.condition_filter
      duration   = var.condition_duration
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone", "resource.label.instance_id"]
      }
      threshold_value = var.threshold_value
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook_content
  }
  notification_channels = var.notification_channels
}