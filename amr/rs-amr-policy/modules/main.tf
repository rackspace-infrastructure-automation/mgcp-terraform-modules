provider "google" {
    version          = "=>3.37.0"
}

terraform {
    required_version = "=>0.13.2"
}

watchman_token       = "123XYZ"

module "general_cpu" {
    source                 = "mgcp-terraform-modules/amr/rs-amr-policy/modules/amr"
    project_id             = "ops-nick-freckleton1"
    policy_display_name    = "rax-amr-instance-cpu-utilization"
    condition_display_name = "CPU Utilization check for GCE INSTANCEs"
    condition_filter       = <<EOT
              metric.type="compute.googleapis.com/instance/uptime" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
    condition_duration     = "300s"
    runbook_content        = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
             2. `gcloud --project ${var.project_id} compute instances stop INSTANCE_NAME`
             3. `gcloud --project ${var.project_id} compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project ${var.project_id} compute instances start INSTANCE_NAME`
          EOT
    notification_channels  = [google_monitoring_notification_channel.rackspace_emergency.name]
}