provider "google" {
  version = ">=3.37.0"
  project = var.project_id
}

terraform {
  required_version = ">=0.12.0"
}

module "gce_cpu" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "OR"
  policy_display_name    = "rax-amr-gce-cpu-utilization"
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
             2. `gcloud --project PROJECT_ID compute instances stop INSTANCE_NAME`
             3. `gcloud --project PROJECT_ID  compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project PROJECT_ID  compute instances start INSTANCE_NAME`
          EOT
  notification_channels  = [module.gce_cpu.rackspace_urgent_id]
  watchman_token         = var.watchman_token
  enabled                = true
}

module "gce_memory" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "OR"
  policy_display_name    = "rax-amr-gce-mem-utilization"
  condition_display_name = "MEM Utilization check for GCE INSTANCEs"
  condition_filter       = <<EOT
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/memory/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
  condition_duration     = "300s"
  runbook_content        = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
             2. `gcloud --project PROJECT_ID  compute instances stop INSTANCE_NAME`
             3. `gcloud --project PROJECT_ID compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project PROJECT_ID  compute instances start INSTANCE_NAME`
          EOT
  notification_channels  = [module.gce_mem.rackspace_urgent_id]
  watchman_token         = var.watchman_token
  enabled                = true
}

module "gce_disk" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "AND_WITH_MATCHING_RESOURCE"
  policy_display_name    = "rax-amr-gce-disk_utilization"
  condition_display_name = "DISK Utilization check for GCE INSTANCEs"
  condition_filter       = <<EOT
              metric.label.state="used" AND
              metric.type="agent.googleapis.com/memory/percent_used" AND
              metadata.user_labels.autoscaled="false" AND
              metadata.user_labels.monitored="true" AND
              resource.type="gce_instance"
      EOT
  condition_duration     = "300s"
  runbook_content        = <<EOT
             1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
             2. `gcloud --project PROJECT_ID  compute instances stop INSTANCE_NAME`
             3. `gcloud --project PROJECT_ID compute instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
             4. `gcloud --project PROJECT_ID  compute instances start INSTANCE_NAME`
          EOT
  notification_channels  = [module.gce_disk.rackspace_urgent_id]
  watchman_token         = var.watchman_token
  enabled                = true
}