
### Toolstation Alerts

resource "google_monitoring_alert_policy" "Prod-CountReplicaLag-emergency" {
  display_name = "Prod-CountReplicaLag-emergency"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "[toolstation]-[emergency]-[count_replica_lag]-[prod-uk]"
    condition_threshold {
      filter     = <<EOT
              metric.type="agent.googleapis.com/mysql/slave_replication_lag" AND
              resource.type="gce_instance" AND
              resource.label.project_id="${var.prod_project}" AND
              metadata.user_labels.monitored="true" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.system_labels.name=monitoring.regex.full_match(".*mysql.*slave.*")
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
        cross_series_reducer = "REDUCE_COUNT"
        group_by_fields    = ["resource.label.project_id", "metric.label.instance_name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 8
      trigger {
        count = 1
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = var.content_emergency
#    content   = "Count of MySql servers is decreased"
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}