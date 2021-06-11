### Uptime Check

resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "rax-mgcp-monitoring-instance-uptime-check"
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
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone", "resource.label.instance_id"]
      }
      threshold_value = 1
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
          1. Ensure instance is responding.\n
             1. See [GCE Instance Connectivity](https://one.rackspace.com/display/MGCP/GCP+Instance+Connectivity) for connectivity instructions.\n
                - NOTE: Restart stackdriver monitoring agent if instance is accessible but alert is showing absent uptime metric.\n
          2. If no response, restart instance.\n
             1. `gcloud --project ${var.project_id} compute instances reset INSTANCE`\n
          3. If unable to diagnosis issue or resolve errors, call customer escalation list \n
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

### Disk Usage

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
              resource.type="gce_instance" AND
              metric.label.device!=monitoring.regex.full_match(".*(loop[0-9]|tmpfs|udev).*")

      EOT
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "metric.label.device", "resource.label.zone"]
      }
      threshold_value = 90
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
      1. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

### CPU Utilisation

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
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.95
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type
             2. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

### Network Usage (Per CPU Core)

resource "google_monitoring_alert_policy" "network_usage" {
  display_name = "rax-mgcp-monitoring-network_usage"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.state="used" AND
              metric.type="compute.googleapis.com/instance/network/received_bytes_count" AND
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
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value =  250000384 * reserved_cpu_cores
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type
             2. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

### Memory Utilisation

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
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 98
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type
             1. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             1. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             1. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

### Disk Performance Exhaustion
## SSD Disks

resource "google_monitoring_alert_policy" "ssd_write_iops" {
  display_name = "rax-optimizer-plus-monitoring-ssd_write_ops"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s SSD's"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/disk/write_ops_count"
              resource.type="gce_instance"
              metric.label.storage_type="pd-ssd"
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 98
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type
             1. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             1. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             1. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}





### NGW Dropped Connections

resource "google_monitoring_alert_policy" "nat_gw" {
  display_name = "rax-mgcp-monitoring-nat_gw_dropped_conn-emergency"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "NAT Gateway Dropped Connections"
    condition_threshold {
      filter     = <<EOT
          metric.type="logging.googleapis.com/user/nat_gw_dropped_conn" resource.type="nat_gateway"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.label.project_id", "resource.label.router_id", "resource.label.region", "resource.label.gateway_name"]

      }
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Increase `minPortsPerVm`
                1. See the [compute_router_nat](https://www.terraform.io/docs/providers/google/r/compute_router_nat.html) Terraform resource documentation for more information.
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
  depends_on            = [google_logging_metric.nat_gw_dropped_conn]
}

### NAT GW Logging metric

resource "google_logging_metric" "nat_gw_dropped_conn" {
  count  = lookup(var.nat_alert, "enabled", false) == true ? 1 : 0
  name   = "nat_gw_dropped_conn"
  filter = "resource.type=nat_gateway AND jsonPayload.allocation_status=DROPPED"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}
