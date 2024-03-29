resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "RS-Base-GCE-Uptime-Check"
  combiner     = "OR"
  enabled      = false
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
  for_each     = toset(var.url_list)
  display_name = "${split("/", split("//", replace(each.key, ".", "-"))[1])[0]}-url-monitor" #https://www.rackspace.com/index.html -> www-rackspace-com-url-monitor
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = replace(replace(each.key, "${split("//", each.key)[0]}//", ""), split("/", split("//", each.key)[1])[0], "") #https://www.rackspace.com/index.html -> /index.html
    port         = startswith(each.key, "https") == true ? "443" : "80"
    use_ssl      = startswith(each.key, "https") == true ? true : false
    validate_ssl = startswith(each.key, "https") == true ? true : false
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = split("/", split("//", each.key)[1])[0] #https://www.rackspace.com/index.html -> www.rackspace.com
    }
  }
}

resource "google_monitoring_alert_policy" "url_uptime_check" {
  count        = length(var.url_list) == 0 ? 0 : 1
  display_name = "RS - Uptime Check URL - Check passed"
  combiner     = "OR"
  enabled      = false
  alert_strategy {
    auto_close = "1800s"
  }
  conditions {
    display_name = "Uptime check for GCE INSTANCE - Platform"
    condition_threshold {
      filter     = <<EOT
              resource.type="uptime_url" AND
              metric.type="monitoring.googleapis.com/uptime_check/check_passed"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_FRACTION_TRUE"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["project", "resource.label.host"]
      }
      threshold_value = 0.5
      trigger {
        count = 1
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_normal.name]
}

resource "google_monitoring_alert_policy" "url_ssl_expiry_alert" {
  count        = length(var.url_list) == 0 ? 0 : 1
  display_name = "RS - SSL Expiry Alert"
  combiner     = "OR"
  enabled      = false
  alert_strategy {
    auto_close = "1800s"
  }
  conditions {
    display_name = "Uptime Check URL - Time until SSL certificate expires"
    condition_threshold {
      filter     = <<EOT
              resource.type = "uptime_url" AND
              metric.type = "monitoring.googleapis.com/uptime_check/time_until_ssl_cert_expires"
      EOT
      duration   = "0s"
      comparison = "COMPARISON_LT"
      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MIN"
        group_by_fields      = ["project", "resource.label.host"]
      }
      threshold_value = 28
      trigger {
        count = 1
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.rackspace_normal.name]
}