resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "RS-Base-GCE-Uptime-Check"
  combiner     = "OR"
  enabled      = var.uptime_check["enabled"]
  alert_strategy {
    auto_close = "86400s"
  }
  conditions {
    display_name = "Uptime check for GCE INSTANCE - Platform"
    condition_threshold {
      filter     = <<EOT
              metric.type="compute.googleapis.com/instance/uptime" AND
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
  notification_channels = [google_monitoring_notification_channel.rackspace_normal.name]
}

resource "google_monitoring_uptime_check_config" "url_monitors" {
  for_each = toset(split("//", replace(each.key,".","-"))[0])
  display_name = concat(split("//", replace(each.key,".","-"))[0], "-url-monitor")
  timeout      = "10s"
  period = "60s"

  http_check {
    path         = "/"
    port         =  substring(each.key, 0, 5) == "https" ? "443" : "80"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host       = each.key
    }
  }

}