resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "rax-mgcp-monitoring-instance-uptime-check"
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
          1. If no response, restart instance.\n
             1. `gcloud --project ${var.project_id} compute instances reset INSTANCE`\n
          1. If unable to diagnosis issue or resolve errors, call customer escalation list \n
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

resource "google_monitoring_alert_policy" "disk_usage" {
  count        = var.disk_usage["disk_percentage"] > 0 ? 1 : 0
  display_name = "rax-mgcp-monitoring-disk_usage-emergency"
  combiner     = "OR"
  enabled      = lookup(var.disk_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/disk/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance" AND
              metric.label."device"!=monitoring.regex.full_match(".*(loop[0-9]|tmpfs|udev).*")
      EOT
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "metric.label.device", "resource.label.zone", "resource.label.instance_id"]
      }
      threshold_value = lookup(var.disk_usage, "disk_percentage", 90)
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

resource "google_monitoring_alert_policy" "memory_usage" {
  display_name = "rax-mgcp-monitoring-memory_usage"
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
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = lookup(var.memory_usage, "mem_threshold", 90)
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

resource "google_monitoring_alert_policy" "nat_gw" {
  count        = lookup(var.nat_alert, "enabled", false) == true ? 1 : 0
  display_name = "rax-mgcp-monitoring-nat_gw_dropped_conn-emergency"
  combiner     = "OR"
  enabled      = lookup(var.nat_alert, "enabled", false)
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

resource "google_monitoring_alert_policy" "ssh_rdp_open_fw" {
  count        = lookup(var.ssh_rdp_fw_alert, "enabled", false) == true ? 1 : 0
  display_name = "rax-mgcp-monitoring-insecure_ssh_rdp_fw_created-emergency"
  combiner     = "OR"
  enabled      = lookup(var.ssh_rdp_fw_alert, "enabled", false)
  conditions {
    display_name = "Insecure SSH/RDP Rule Opened"
    condition_threshold {
      filter     = <<EOT
          metric.type="logging.googleapis.com/user/insecure_ssh_rdp_fw_created" resource.type="global"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["metric.label.project"]

      }
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
            !!! DO NOT RESOLVE THIS ALERT WITHOUT VERIFYING IN THE CONSOLE FIRST IF THE ALERT TICKET SAYS ALARM CLEARED !!!
             1. An insecure firewall has been opened on ports 22 and/or 3389 with a source range of 0.0.0.0/0.
                1. Disable the rule immediately
                1. Check who has created the rule. If it was a Racker reach out to them via Teams and let them know they've created an insecure rule and they need to lock it down. If it was the customer call them immediately and let them know.
                1. Work with the customer to lock down the rule to specific source ranges if applicable.
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
  depends_on            = [google_logging_metric.insecure_ssh_rdp_fw_created]
}

### SSH RDP FW Rule Logging metric

resource "google_logging_metric" "insecure_ssh_rdp_fw_created" {
  count  = lookup(var.ssh_rdp_fw_alert, "enabled", false) == true ? 1 : 0
  name   = "insecure_ssh_rdp_fw_created"
  filter = <<EOT
      (protoPayload.methodName=("v1.compute.firewalls.insert" OR "v1.compute.firewalls.patch" OR "beta.compute.firewalls.insert" OR "beta.compute.firewalls.patch") protoPayload.request.sourceRanges="0.0.0.0/0" protoPayload.request.alloweds.ports=("22" OR "3389")) OR (protoPayload.methodName=("v1.compute.firewalls.patch" OR "beta.compute.firewalls.patch") protoPayload.resourceOriginalState.sourceRanges="0.0.0.0/0" protoPayload.request.alloweds.ports=("22" OR "3389")) OR (protoPayload.methodName=("v1.compute.firewalls.patch" OR "beta.compute.firewalls.patch") protoPayload.request.sourceRanges="0.0.0.0/0" protoPayload.resourceOriginalState.alloweds.ports=("22" OR "3389"))
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}
