resource "google_cloudfunctions2_function" "toggle_monitoring_off" {
  provider   = google-beta
  name       = "toggle-monitoring-off"
  location   = var.region
  depends_on = [google_project_iam_member.service_agent]

  build_config {
    runtime     = "python39"
    entry_point = "toggle_monitoring_off"

    source {
      storage_source {
        bucket = "toggle-monitoring"
        object = "toggle-monitoring-off.zip"
      }
    }
  }

  event_trigger {
    trigger_region = "global"
    event_type     = "google.cloud.audit.log.v1.written"
    retry_policy   = "RETRY_POLICY_RETRY"
    event_filters {
      attribute = "methodName"
      value     = "v1.compute.instances.stop"
    }
    event_filters {
      attribute = "serviceName"
      value     = "compute.googleapis.com"
    }
  }
  service_config {
    environment_variables = {
      "excluded_instances" = "[${join(", ", [for s in var.excluded_instances : format("%q", s)])}]"
    }
  }
}

resource "google_cloudfunctions2_function" "toggle_monitoring_on" {
  provider   = google-beta
  name       = "toggle-monitoring-on"
  location   = var.region
  depends_on = [google_project_iam_member.service_agent]

  build_config {
    runtime     = "python39"
    entry_point = "toggle_monitoring_on"

    source {
      storage_source {
        bucket = "toggle-monitoring"
        object = "toggle-monitoring-on.zip"
      }
    }
  }

  event_trigger {
    trigger_region = "global"
    event_type     = "google.cloud.audit.log.v1.written"
    retry_policy   = "RETRY_POLICY_RETRY"
    event_filters {
      attribute = "methodName"
      value     = "v1.compute.instances.start"
    }
    event_filters {
      attribute = "serviceName"
      value     = "compute.googleapis.com"
    }
  }
  service_config {
    environment_variables = {
      "excluded_instances" = "[${join(", ", [for s in var.excluded_instances : format("%q", s)])}]"
    }
  }
}
