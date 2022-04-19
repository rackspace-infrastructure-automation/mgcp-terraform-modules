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

resource "google_monitoring_alert_policy" "windows_disk_usage" {
  count        = lookup(var.windows_disk_usage, "blk_dev_name", "") == "C:" ? 1 : 0
  display_name = "rax-mgcp-monitoring-disk_usage-${lookup(var.windows_disk_usage, "blk_dev_name", "")}-emergency"
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
      threshold_value = lookup(var.memory_usage, "disk_threshold_percentage", 90)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
          1. Login to the Windows GCE instance
             1. See [GCE Instance Connectivity](https://one.rackspace.com/display/MGCP/GCP+Instance+Connectivity) for connectivity instructions.
          1. Run Disk Cleanup Utility
             1. From a command prompt (cmd or PS) and run `cleanmgr.exe /d c:`
             1. Press `Cleanup system files`
             1. Select all items and press OK
          1. If this is still not enough, expand the drive by 10%
             1. `gcloud --project ${var.project_id} compute disks resize DISK_NAME --size CURRENT_SIZE+10%`
             1. Open Disk Management (run diskmgmt.msc from cmd or PS), right click on the C: partition, and select `Extend Volume`
             1. Select to expand the drive to the maximum available size and press OK
          1. Identify the largest folders and inform the customer
             1. From PowerSheel download Treesize with the following command:
             gsutil cp gs://rs-windows-remediation/TreeSize.exe $env:USERPROFILE\Desktop
             1. Locate `TreeSize.exe` in the VM Desktop and execute it
             1. Double click on the C: drive to Scan.
             1. Right click on the C: drive on the top left pane and select Export -> Export to Excel
             1. Name the file "Largest_Folders.xls" and save it to the desktop.
             1. Copy and paste the file into your local desktop
             1. Update the ticket informing the customer that we have expanded the drive by 10% and request him to review the list of the largest folders attached to the ticket
             1. Attach the excel file to the ticket
          1. If the C: drive fills up again and the alert keeps firing
             1. Call the customer
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

resource "google_monitoring_alert_policy" "rhel_disk_usage" {
  count        = lookup(var.rhel_disk_usage, "blk_dev_name", "") == "sda1" ? 1 : 0
  display_name = "rax-mgcp-monitoring-disk_usage-${lookup(var.rhel_disk_usage, "blk_dev_name", "")}-emergency"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.rhel_disk_usage, "enabled", false)
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
      threshold_value = lookup(var.rhel_disk_usage, "disk_threshold_bytes", 0)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
          1. Grow disk by 10 GB
             1. `gcloud --project ${var.project_id} compute disks resize DISK_NAME --size CURRENT_SIZE+10`
          1. Login to the GCE instance
             1. See [GCE Instance Connectivity](https://one.rackspace.com/display/MGCP/GCP+Instance+Connectivity) for connectivity instructions.
          1. Grow filesystem
             1. See [OS resize](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize) for instructions to resize filesystem.
                - NOTE: You may need to connect through a bastion host if instance has private address only.
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

resource "google_monitoring_alert_policy" "debian_disk_usage" {
  count        = lookup(var.debian_disk_usage, "blk_dev_name", "") == "root" ? 1 : 0
  display_name = "rax-mgcp-monitoring-disk_usage-${lookup(var.debian_disk_usage, "blk_dev_name", "")}-emergency"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.debian_disk_usage, "enabled", false)
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
      threshold_value = lookup(var.memory_usage, "mem_threshold", 90)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
          1. Grow disk by 10 GB
             1. `gcloud --project ${var.project_id} compute disks resize DISK_NAME --size CURRENT_SIZE+10`
          1. Login to the GCE instance
             1. See [GCE Instance Connectivity](https://one.rackspace.com/display/MGCP/GCP+Instance+Connectivity) for connectivity instructions.
          1. Grow filesystem
             1. See [OS resize](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize) for instructions to resize filesystem.
                - NOTE: You may need to connect through a bastion host if instance has private address only.
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
             1. An insecure firewall has been opened on ports 22 and/or 3389 with a source range of 0.0.0.0/0.
                1. Disable the rule immediately
                1. Check who has created the rule. If it was a Racker reach out to them via Teams and let them know they've created an insecure rule and they need to lock it down. If it was the customer call them immediately and let them know.
                1. Work with the customer to lock down the rule to specific source ranges if applicable.
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
  depends_on            = [google_logging_metric.insecure_ssh_rdp_fw_created]
}

### NAT GW Logging metric

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
