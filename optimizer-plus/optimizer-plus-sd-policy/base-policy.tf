provider "google" {
  project = var.project_id
}

resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "rax-optimizer-plus-monitoring-instance-uptime-check"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "Uptime check for GCE INSTANCE - Platform"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/uptime" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["project", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 1
      trigger {
        count = 1
      }
    }

  }
}

resource "google_monitoring_alert_policy" "cpu_usage" {
  display_name = "rax-optimizer-plus-monitoring-cpu_usage"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/cpu/utilization" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 1.0
      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "memory_usage" {
  display_name = "rax-optimizer-plus-monitoring-memory_usage"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/memory/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = 90
      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "disk_usage" {
  display_name = "rax-optimizer-plus-monitoring-disk_usage"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = true  
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="agent.googleapis.com/disk/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "resource.label.instance_id", "metric.label.device" , "resource.label.zone"]
      }
      threshold_value = 90
      trigger {
        count = 1
      }
    }
  }
}
