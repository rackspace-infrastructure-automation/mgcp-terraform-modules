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
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
          1. Ensure instance is responding.\n
             1. Connect to the machine via IAP / SSH / RDP.\n
                - NOTE: Restart stackdriver monitoring agent if instance is accessible but alert is showing absent uptime metric.\n
          1. If no response, restart instance.\n
             1. `gcloud --project ${var.project_id} compute instances reset INSTANCE`\n
          1. Troubleshoot or escalate if issue still exists\n"
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
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
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. If required, resize instance up one machine type
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
             1. Connect to the machine via IAP / SSH / RDP.\n
          1. Run Disk Cleanup Utility
             1. From a command prompt (cmd or PS) and run `cleanmgr.exe /d c:`
             1. Press `Cleanup system files`
             1. Select all items and press OK
          1. If this is still not enough, you may wish to expand the drive by 10%
             1. `gcloud --project ${var.project_id} compute disks resize DISK_NAME --size CURRENT_SIZE+10%`
             1. Open Disk Management (run diskmgmt.msc from cmd or PS), right click on the C: partition, and select `Extend Volume`
             1. Select to expand the drive to the maximum available size and press OK
          1. Identify the largest folders
             1. From PowerShell download Treesize with the following command:
             gsutil cp gs://rs-windows-remediation/TreeSize.exe $env:USERPROFILE\Desktop
             1. Locate `TreeSize.exe` in the VM Desktop and execute it
             1. Double click on the C: drive to Scan.
             1. Right click on the C: drive on the top left pane and select Export -> Export to Excel
             1. Name the file "Largest_Folders.xls" and save it to the desktop.
             1. Copy and paste the file into your local desktop
             1. Update the ticket informing the customer that we have expanded the drive by 10% and request him to review the list of the largest folders attached to the ticket
             1. Attach the excel file to the ticket
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
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