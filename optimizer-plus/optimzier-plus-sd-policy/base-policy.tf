resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "rax-optimizer-plus-monitoring-instance-uptime-check"
  combiner     = "OR"
  enabled      = lookup(var.uptime_check, "enabled", false)
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
        group_by_fields      = ["resource.label.instance_id"]
      }
      threshold_value = 1
      trigger {
        count = 1
      }
    }

  }
}

resource "google_monitoring_alert_policy" "memory_usage" {
  display_name = "rax-optimizer-plus-mmonitoring-memory_usage"
  combiner     = "AND"
  enabled      = lookup(var.memory_usage, "enabled", false)
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
      threshold_value = lookup(var.memory_usage, "mem_threshold", 90)
      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "windows_disk_usage" {
  count        = lookup(var.windows_disk_usage, "blk_dev_name", "") == "C:" ? 1 : 0
  display_name = "rax-optimizer-plus-monitoring-disk_usage-${lookup(var.windows_disk_usage, "blk_dev_name", "")}-emergency"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.windows_disk_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.device="${lookup(var.windows_disk_usage, "blk_dev_name", 90)}" AND
              metric.label.state="used" AND
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
        group_by_fields      = ["project", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = lookup(var.windows_disk_usage, "disk_threshold_percentage", 90)
      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "rhel_disk_usage" {
  count        = lookup(var.rhel_disk_usage, "blk_dev_name", "") == "sda1" ? 1 : 0
  display_name = "rax-optimizer-plus-monitoring-disk_usage-${lookup(var.rhel_disk_usage, "blk_dev_name", "")}-emergency"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.windows_disk_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.device="${lookup(var.rhel_disk_usage, "blk_dev_name", "")}" AND
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/disk/bytes_used" AND
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
      threshold_value = lookup(var.rhel_disk_usage, "disk_threshold_percentage", 90)
      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "debian_disk_usage" {
  count        = lookup(var.debian_disk_usage, "blk_dev_name", "") == "root" ? 1 : 0
  display_name = "rax-optimizer-plus-monitoring-disk_usage-${lookup(var.debian_disk_usage, "blk_dev_name", "")}-emergency"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.windows_disk_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.device="${lookup(var.debian_disk_usage, "blk_dev_name", "root")}" AND
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/disk/bytes_used" AND
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
      threshold_value = lookup(var.memory_usage, "disk_threshold_percentage", 90)
      trigger {
        count = 1
      }
    }
  }
}