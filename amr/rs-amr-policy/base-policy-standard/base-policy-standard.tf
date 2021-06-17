## GCE
# Uptime Check

resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "rax-amr-instance-uptime-check"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "Uptime check for GCE INSTANCE"
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

# CPU Utilisation

resource "google_monitoring_alert_policy" "cpu_usage" {
  display_name = "rax-amr-monitoring-cpu_usage"
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
      threshold_value = 0.99
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
             2. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# Network Usage (Per CPU Core)

resource "google_monitoring_alert_policy" "network_usage" {
  display_name = "rax-amr-network_usage"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
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
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
             2. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# Memory Usage Percentage

resource "google_monitoring_alert_policy" "memory_usage" {
  display_name = "rax-amr-monitoring-memory_usage"
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
      threshold_value = 99
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
             1. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             1. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             1. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# Disk Usage Percentage

resource "google_monitoring_alert_policy" "disk_usage" {
  display_name = "rax-amr-monitoring-disk_usage"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.state="used" AND
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

## Disk Performance IO
# SSD RW IO GCE

resource "google_monitoring_alert_policy" "ssd_read_write_ops" {
  display_name = "rax-amr-monitoring-ssd_read_write_ops"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/disk/write_ops_count" OR
              metric.type="compute.googleapis.com/instance/disk/read_ops_count"
              resource.type="gce_instance"
              metric.label.storage_type="pd-ssd"
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 30 * GB
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Increase size of persistent SSD drive by 10 GB or calculate the maximum IOPS required and increase by 1 GB for every 30 IOPS required.
             2. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

## Standard Disk 
# Write OPS

resource "google_monitoring_alert_policy" "std_write_ops" {
  display_name = "rax-amr-monitoring-std_write_ops"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/disk/write_ops_count"
              resource.type="gce_instance"
              metric.label.storage_type="pd-standard"
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.75 * GB
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Increase size of persistent SSD drive by 10 GB or calculate the maximum IOPS required and increase by 1 GB for every 30 IOPS required.
             2. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# Read OPS

resource "google_monitoring_alert_policy" "std_read_ops" {
  display_name = "rax-amr-monitoring-std_read_ops"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/disk/read_ops_count"
              resource.type="gce_instance"
              metric.label.storage_type="pd-standard"
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 1.5 * GB
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Increase size of persistent SSD drive by 10 GB or calculate the maximum IOPS required and increase by 1 GB for every 30 IOPS required.
             2. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

## Read Write Bytes
# SSD RW Bytes

resource "google_monitoring_alert_policy" "ssd_read_write_bytes" {
  display_name = "rax-amr-monitoring-ssd_read_write_bytes"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/disk/write_bytes_count" OR
              metric.type="compute.googleapis.com/instance/disk/read_bytes_count"
              resource.type="gce_instance"
              metric.label.storage_type="pd-ssd"
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.48 * GB
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Increase size of persistent SSD drive by 10 GB or calculate the maximum IOPS required and increase by 1 GB for every 30 IOPS required.
             2. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# STD RW Bytes

resource "google_monitoring_alert_policy" "std_read_write_bytes" {
  display_name = "rax-amr-monitoring-std_read_write_bytes"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/disk/write_bytes_count" OR
              metric.type="compute.googleapis.com/instance/disk/read_bytes_count"
              resource.type="gce_instance"
              metric.label.storage_type="pd-ssd"
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.12 * GB
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Increase size of persistent SSD drive by 10 GB or calculate the maximum IOPS required and increase by 1 GB for every 30 IOPS required.
             2. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

## Cloud SQL
# CPU Utilization

resource "google_monitoring_alert_policy" "csql_cpu_utilization" {
  display_name = "rax-amr-monitoring-csql_cpu_utilization"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Cloud SQL (CSQL)"
    condition_threshold {
      filter     = <<EOT
              metric.type="cloudsql.googleapis.com/database/cpu/utilization" AND
              metadata.user_labels.monitored="true" AND
              resource.type="cloudsql_database"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.99
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
              1. Restarts can take up to 60 minutes if slow queries or persistent connections are used
             2. `gcloud --project ${var.project_id} sql instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} sql instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# Memory Utilization

resource "google_monitoring_alert_policy" "csql_memory_utilization" {
  display_name = "rax-amr-monitoring-csql_memory_utilization"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Cloud SQL (CSQL)"
    condition_threshold {
      filter     = <<EOT
              metric.type="cloudsql.googleapis.com/database/memory/utilization" AND
              metadata.user_labels.monitored="true" AND
              resource.type="cloudsql_database"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.99
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
              1. Restarts can take up to 60 minutes if slow queries or persistent connections are used
             1. `gcloud --project ${var.project_id} sql instances stop INSTANCE_NAME`
             1. `gcloud --project ${var.project_id} sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud sql instances set-machine-type --help` for more options.
             1. `gcloud --project ${var.project_id} sql instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

# MySQL Replication Lag

resource "google_monitoring_alert_policy" "csql_mysql_seconds_behind_master" {
  display_name = "rax-amr-monitoring-csql_mysql_rseconds_behind_master"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All MySQL Cloud SQL (CSQL)"
    condition_threshold {
      filter     = <<EOT
              metric.type="database/mysql/replication/seconds_behind_master" AND
              metadata.user_labels.monitored="true" AND
              resource.type="cloudsql_database"
      EOT
      duration   = "1200s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Contact customer escalation or DBA team as appropriate 
              1. This metric relies heavily on the number of incomming updates to the master DB
             2. Consider upgrading the replica node type, troubleshooting, or enabling Parralell replication (5.7 + 8.0)
              1. https://cloud.google.com/sql/docs/mysql/replication/manage-replicas#configuring-parallel-replication
              2. https://cloud.google.com/sql/docs/mysql/replication/manage-replicas#troubleshooting
              3. `gcloud --project ${var.project_id} sql instances stop INSTANCE_NAME`
              3. `gcloud --project ${var.project_id} sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud sql instances set-machine-type --help` for more options.
              3. `gcloud --project ${var.project_id} sql instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

## Kubernetes
# Node CPU Usage Time

resource "google_monitoring_alert_policy" "k8s_node_cpu_utilization" {
  display_name = "rax-amr-monitoring-k8s_node_cpu_utilization"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Kubernetes Nodes (k8s)"
    condition_threshold {
      filter     = <<EOT
              metric.type="kubernetes.io/node/cpu/core_usage_time" AND
              metadata.user_labels.monitored="true" AND
              resource.type="k8s_node"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 0.99
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Double the max size of the nodepool.	
              1. Note: 1 second is equal to 100% usage of one CPU core.
              1. Restarts can take up to 60 minutes if slow queries or persistent connections are used
             2. `gcloud --project ${var.project_id} sql instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} sql instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

# Node Memory Usage (Bytes)

resource "google_monitoring_alert_policy" "k8s_node_mem_usage" {
  display_name = "rax-amr-monitoring-k8s_node_mem_usage"
  combiner     = "AND"
  enabled      = true
  conditions {
    display_name = "Metric Threshold on All Kubernetes Nodes (k8s)"
    condition_threshold {
      filter     = <<EOT
              metric.type="kubernetes.io/node/memory/used_bytes" AND
              metadata.user_labels.monitored="true" AND
              resource.type="k8s_node"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = 37.6
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Double the max size of the nodepool.	
              1. Note: 1 second is equal to 100% usage of one CPU core.
              1. Restarts can take up to 60 minutes if slow queries or persistent connections are used
             2. `gcloud --project ${var.project_id} sql instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} sql instances start INSTANCE_NAME`
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

## Nat Gateway
# NGW Allocatoin Failure (Dropped Connection)

resource "google_monitoring_alert_policy" "nat_allocation_failed" {
  display_name = "rax-amr-nat_allocation_failed_emergency"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "NAT Gateway Allocation Failure"
    condition_threshold {
      filter     = <<EOT
          metric.type="router.googleapis.com/nat/nat_allocation_failed" 
          resource.type="nat_gateway"
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
}

# NGW Port Exhaustion

resource "google_monitoring_alert_policy" "nat_gw_port_exhaustion" {
  display_name = "rax-amr-nat_gw_port_exhaustion_urgent"
  combiner     = "OR"
  enabled      = true
  conditions {
    display_name = "NAT Gateway Port Exhaustion"
    condition_threshold {
      filter     = <<EOT
          metric.type="router.googleapis.com/nat/allocated_ports" 
          resource.type="nat_gateway"
      EOT
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.label.project_id", "resource.label.router_id", "resource.label.region", "resource.label.gateway_name"]

      }
      threshold_value = 58060
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<EOT
             1. Assign additional static address. Alternatively, investigate if minPortsPerVM can be reduced.
                1. See the [compute_router_nat](https://www.terraform.io/docs/providers/google/r/compute_router_nat.html) Terraform resource documentation for more information.
             2. Note: 90% of 64512 which is the maximum number of ports that can be allocated to a single NAT address.
          EOT
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}
