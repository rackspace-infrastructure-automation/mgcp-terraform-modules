### Toolstation Alerts

resource "google_monitoring_alert_policy" "CPU_utilization-Urgent" {
  display_name = "CPU_utilization-Urgent"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "[toolstation]-[urgent]-[cpu_utilization]-[mysql]-[prod-uk]"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/cpu/utilization" AND
              resource.type="gce_instance" AND
              resource.label.project_id="${var.prod_project}" AND
              metadata.user_labels.monitored="true" AND
              metadata.user_labels.autoscaled="false" AND
              metric.label.instance_name=monitoring.regex.full_match(".*mysql.*")
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.label.project_id", "metric.label.instance_name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 0.95
      trigger {
        count = 1
      }
    }
  }

  conditions {
    display_name = "[toolstation]-[urgent]-[cpu_utilization]-[ecom]-[prod-uk]"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/cpu/utilization" AND
              resource.type="gce_instance" AND
              resource.label.project_id="${var.prod_project}" AND
              metadata.user_labels.monitored="true" AND
              metadata.user_labels.autoscaled="false" AND
              metric.label.instance_name=monitoring.regex.full_match(".*epos.*")
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.label.project_id", "metric.label.instance_name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 0.95
      trigger {
        count = 1
      }
    }
  }

  conditions {
    display_name = "[toolstation]-[urgent]-[cpu_utilization]-[extranet]-[prod-uk]"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/cpu/utilization" AND
              resource.type="gce_instance" AND
              resource.label.project_id="${var.prod_project}" AND
              metadata.user_labels.monitored="true" AND
              metadata.user_labels.autoscaled="false" AND
              metric.label.instance_name=monitoring.regex.full_match(".*extranet.*")
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.label.project_id", "metric.label.instance_name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 0.95
      trigger {
        count = 1
      }
    }
  }

  conditions {
    display_name = "[toolstation]-[urgent]-[cpu_utilization]-[tradecredit]-[prod-uk]"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/cpu/utilization" AND
              resource.type="gce_instance" AND
              resource.label.project_id="${var.prod_project}" AND
              metadata.user_labels.monitored="true" AND
              metadata.user_labels.autoscaled="false" AND
              metric.label.instance_name=monitoring.regex.full_match(".*trade-credit-s.*")
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.label.project_id", "metric.label.instance_name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 0.95
      trigger {
        count = 1
      }
    }
  }

  conditions {
    display_name = "[toolstation]-[urgent]-[cpu_utilization]-[cloud_sql]-[prod-uk]"
    condition_threshold {
      filter     = <<EOT
              metric.type="cloudsql.googleapis.com/database/cpu/utilization" AND
              resource.type="cloudsql_database" AND
              resource.label.project_id="${var.prod_project}" AND
              metadata.system_labels.name="prod-db-content-01"
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.label.project_id", "resource.label.database_id", "resource.label.region"]
      }
      threshold_value = 0.95
      trigger {
        count = 1
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = var.content_urgent
#    content   = "The percentage of CPU utilization"
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}