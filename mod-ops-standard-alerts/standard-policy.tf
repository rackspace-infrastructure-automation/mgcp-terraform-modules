resource "google_monitoring_alert_policy" "cpu_usage" {
  display_name = "RS-Base-GCE-CPU-Utilization"
  combiner     = "AND"
  enabled      = lookup(var.cpu_uage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/cpu/utilization" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored ="true"
              resource.type="gce_instance"
      EOT
      duration   = "300s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "900s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.zone"]
      }
      threshold_value = lookup(var.cpu_uage, "cpu_threshold", 0.95)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_high.name]
}

resource "google_monitoring_alert_policy" "memory_usage_urgent" {
  display_name = "RS-Base-GCE-Memory-Utilization-Urgent"
  combiner     = "AND"
  enabled      = lookup(var.memory_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/memory/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored ="true"
              resource.type="gce_instance"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = lookup(var.memory_usage, "mem_threshold_urgent", 98)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

resource "google_monitoring_alert_policy" "memory_usage_high" {
  display_name = "RS-Base-GCE-Memory-Utilization-Urgent-High"
  combiner     = "AND"
  enabled      = lookup(var.memory_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/memory/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored ="true"
              resource.type="gce_instance"
      EOT
      duration   = "900s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "resource.label.instance_id", "resource.label.zone"]
      }
      threshold_value = lookup(var.memory_usage, "mem_threshold_high", 95)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_high.name]
}


resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "RS-Base-GCE-Uptime-Check"
  combiner     = "OR"
  enabled      = lookup(var.uptime_check, "enabled", false)
  conditions {
    display_name = "Uptime check for GCE INSTANCE - Platform"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/uptime" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored ="true"
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
    content   = var.runbook
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_emergency.name]
}

resource "google_monitoring_alert_policy" "disk_usage" {
  display_name = "RS-Base-GCE-Disk-Utilization"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.disk_usage, "enabled", false)
  conditions {
    display_name = "Metric Threshold on All Instance (GCE)s"
    condition_threshold {
      filter     = <<EOT
              metric.type="agent.googleapis.com/disk/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              resource.type="gce_instance" AND
              metric.label.device!=monitoring.regex.full_match(".*(loop[0-9]|tmpfs|udev).*") AND
              metric.label.state="free"

      EOT
      duration   = "60s"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "metadata.system_labels.name", "metric.label.device", "resource.label.zone"]
      }
      threshold_value = lookup(var.disk_usage, "disk_percentage", 10)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}



resource "google_monitoring_alert_policy" "nat_dropped_packet_out_of_resource" {
  count        = lookup(var.nat_alert, "enabled", false) == true ? 1 : 0
  display_name = "RS-Base-NAT-Dropped-Packet-Out-Of-Resource"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.nat_alert, "enabled", false)
  conditions {
    display_name = "Cloud NAT Gateway - Sent packets dropped count"
    condition_threshold {
      filter     = <<EOT
              resource.type = "nat_gateway" AND
              metric.type = "router.googleapis.com/nat/dropped_sent_packets_count" AND
              metric.labels.reason = "OUT_OF_RESOURCES"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["metric.label.ip_protocol", "metric.label.reason", "resource.label.project_id", "resource.label.router_id", "project"]
      }
      threshold_value = lookup(var.nat_alert, "threshold_value_dropped_packet", 0)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

resource "google_monitoring_alert_policy" "nat_dropped_packet_endpoint_map" {
  count        = lookup(var.nat_alert, "enabled", false) == true ? 1 : 0
  display_name = "RS-Base-NAT-Dropped-Packet-Endpoint-Map"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.nat_alert, "enabled", false)
  conditions {
    display_name = "Cloud NAT Gateway - Sent packets dropped count"
    condition_threshold {
      filter     = <<EOT
              resource.type = "nat_gateway" AND
              metric.type = "router.googleapis.com/nat/dropped_sent_packets_count" AND
              metric.labels.reason = "ENDPOINT_INDEPENDENCE_CONFLICT"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["metric.label.ip_protocol", "metric.label.reason", "resource.label.project_id", "resource.label.router_id", "project"]
      }
      threshold_value = lookup(var.nat_alert, "threshold_value_dropped_packet", 0)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

resource "google_monitoring_alert_policy" "nat_allocation_fail" {
  count        = lookup(var.nat_alert, "enabled", false) == true ? 1 : 0
  display_name = "RS-Base-NAT-Allocation-Fail"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.nat_alert, "enabled", false)
  conditions {
    display_name = "Cloud NAT Gateway - NAT allocation failed"
    condition_threshold {
      filter     = <<EOT
              resource.type = "nat_gateway" AND
              metric.type = "router.googleapis.com/nat/nat_allocation_failed"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_COUNT_TRUE"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.label.project_id", "resource.label.region", "resource.label.router_id", "resource.label.gateway_name", ]
      }
      threshold_value = 1
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

resource "google_monitoring_alert_policy" "nat_port_exhaust" {
  count        = lookup(var.nat_alert, "enabled", false) == true ? 1 : 0
  display_name = "RS-Base-NAT-Port-Exhaust"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.nat_alert, "enabled", false)
  conditions {
    display_name = "Cloud NAT Gateway - Allocated ports"
    condition_threshold {
      filter     = <<EOT
              resource.type = "nat_gateway" AND
              metric.type = "router.googleapis.com/nat/allocated_ports"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["metric.label.nat_ip", "resource.label.project_id", "resource.label.router_id", ]
      }
      threshold_value = lookup(var.nat_alert, "threshold_value_allocated_ports", 58060)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

resource "google_monitoring_alert_policy" "csql_memory_utilization" {
  count        = lookup(var.sql_alert, "enabled", false) == true ? 1 : 0
  display_name = "RS-Base-MEM-CSQL"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.nat_alert, "enabled", false)
  conditions {
    display_name = "Cloud SQL Database - Memory utilization"
    condition_threshold {
      filter     = <<EOT
              resource.type = "cloudsql_database" AND
              metric.type = "cloudsql.googleapis.com/database/memory/utilization"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "900s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.label.project_id", "resource.label.database_id", "resource.label.region"]
      }
      threshold_value = lookup(var.sql_alert, "threshold_value_memory", 0.99)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

resource "google_monitoring_alert_policy" "csql_cpu_utilization" {
  count        = lookup(var.sql_alert, "enabled", false) == true ? 1 : 0
  display_name = "RS-Base-CPU-CSQL"
  combiner     = "AND_WITH_MATCHING_RESOURCE"
  enabled      = lookup(var.sql_alert, "enabled", false)
  conditions {
    display_name = "Cloud SQL Database - CPU utilization"
    condition_threshold {
      filter     = <<EOT
              resource.type = "cloudsql_database" AND
              metric.type = "cloudsql.googleapis.com/database/cpu/utilization"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "900s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.label.project_id", "resource.label.database_id", "resource.label.region"]
      }
      threshold_value = lookup(var.sql_alert, "threshold_value_cpu", 0.99)
      trigger {
        count = 1
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = var.runbook
  }

  notification_channels = [google_monitoring_notification_channel.rackspace_urgent.name]
}

