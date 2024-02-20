data "google_project" "project" {
  project_id = var.project_id
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"

  mode = "addititve"

  projects = [var.project_id]

  bindings = {
    "roles/iam.serviceAccountTokenCreator" = [
      "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com",
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
    ]

    "roles/run.serviceAgent" = [
      "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com",
    ]
  }
}

resource "google_cloudfunctions2_function" "toggle_monitoring_off" {
  provider = google-beta
  name     = "toggle-monitoring-off"
  location = var.region
  depends_on = [ module.projects_iam_bindings ]

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
  }
}

resource "google_cloudfunctions2_function" "toggle_monitoring_on" {
  provider = google-beta
  name     = "toggle-monitoring-on"
  location = var.region
  depends_on = [ module.projects_iam_bindings ]

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
  }
}
