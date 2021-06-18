provider "google" {
  version = ">=3.37.0"
  project = var.project_id
}

terraform {
  required_version = ">=0.12.0"
}

### GCE STD Monitors

module "gce_cpu_util" {
  source                 = "./modules/base-policy"
  combiner               = "OR"
  policy_display_name    = "rax-amr-gce_cpu_util"
  condition_display_name = "CPU check for GCE INSTANCEs"
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
  group_by_fields        = ["resource.label.project_id", "metric.label.instance_name", "resource.label.zone", "resource.label.instance_id"]
  notification_channels  = [module.rackspace_urgent.notification_id]
  threshold              = 0.99
}

module "gce_mem_util" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "OR"
  policy_display_name    = "rax-amr-gce_mem_util"
  condition_display_name = "MEM UTIL for GCE INSTANCEs"
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
  notification_channels  = [module.rackspace_urgent.notification_id]
  watchman_token         = var.watchman_token
  threshold              = 99
}

module "gce_disk_usage" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "AND_WITH_MATCHING_RESOURCE"
  policy_display_name    = "rax-amr-gce_disk_usage"
  condition_display_name = "DISK USAGE for GCE INSTANCEs"
  condition_filter       = <<EOT
                           metric.label.state="used" AND
                           metric.type="agent.googleapis.com/disk/percent_used" AND
                           metadata.user_labels.autoscaled="false" AND
                           metadata.user_labels.monitored="true" AND
                           resource.type="gce_instance" AND
                           metric.label.device!=monitoring.regex.full_match(".*(loop[0-9]|tmpfs|udev).*")
                           EOT
  condition_duration     = "60s"
  runbook_content        = <<EOT
                           1. See [Wiki](https://one.rackspace.com/display/MGCP/MGCP+-+Base+Policy+-+Disk+Usage+-+OS+resize)
                           EOT
  notification_channels  = [module.rackspace_urgent.notification_id]
  watchman_token         = var.watchman_token
  threshold              = 90
}

module "gce_uptime_check" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "OR"
  policy_display_name    = "rax-amr-gce_uptime_check"
  condition_display_name = "UPTIME CHECK for GCE INSTANCEs"
  condition_filter       = <<EOT
                           metric.type="compute.googleapis.com/instance/uptime" AND
                           metadata.user_labels.autoscaled="false" AND
                           metadata.user_labels.monitored="true" AND
                           resource.type="gce_instance"
                           EOT
  condition_duration     = "60s"
  comparison             = "COMPARISON_LT"
  runbook_content        = <<EOT
                           1. Ensure instance is responding.\n
                              1. See [GCE Instance Connectivity](https://one.rackspace.com/display/MGCP/GCP+Instance+Connectivity) for connectivity instructions.\n
                                 - NOTE: Restart stackdriver monitoring agent if instance is accessible but alert is showing absent uptime metric.\n
                           2. If no response, restart instance.\n
                              1. `gcloud --project PROJECT_ID compute instances reset INSTANCE`\n
                           3. If unable to diagnosis issue or resolve errors, call customer escalation list \n
                           EOT
  notification_channels  = [module.rackspace_urgent.notification_id]
  watchman_token         = var.watchman_token
  threshold              = 0
}

# ### CSQL Monitors

module "csql_cpu_util" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "AND"
  policy_display_name    = "rax-amr-monitoring-csql_cpu_util"
  condition_display_name = "CPU UTILIZATION for CSQL INSTANCES"
  condition_filter       = <<EOT
                           metric.type="cloudsql.googleapis.com/database/cpu/utilization" AND
                           metadata.user_labels.monitored="true" AND
                           resource.type="cloudsql_database"
                           EOT
  condition_duration     = "900s"
  runbook_content        = <<EOT
                           1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
                              - NOTE: Restarts can take up to 60 minutes if slow queries or persistent connections are used
                           2. `gcloud --project PROJECT_ID sql instances stop INSTANCE_NAME`
                           3. `gcloud --project PROJECT_ID sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                              - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
                           4. `gcloud --project PROJECT_ID sql instances start INSTANCE_NAME`
                           EOT
  notification_channels  = [module.rackspace_urgent.notification_id]
  watchman_token         = var.watchman_token
  threshold              = 0.99
}

module "csql_mem_util" {
  source                 = "./modules/base-policy"
  project_id             = var.project_id
  combiner               = "OR"
  policy_display_name    = "rax-amr-monitoring-csql_memory_util"
  condition_display_name = "MEM UTILIZATION for CSQL INSTANCES"
  condition_filter       = <<EOT
                           metric.type="cloudsql.googleapis.com/database/memory/utilization" AND
                           metadata.user_labels.monitored="true" AND
                           resource.type="cloudsql_database"
                           EOT
  condition_duration     = "900s"
  runbook_content        = <<EOT
                           1. Resize instance up one machine type with customer approval, use IAC unless this is an emergency
                              - NOTE: Restarts can take up to 60 minutes if slow queries or persistent connections are used
                           2. `gcloud --project PROJECT_ID sql instances stop INSTANCE_NAME`
                           3. `gcloud --project PROJECT_ID sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
                              - NOTE: see `gcloud compute instances set-machine-type --help` for more options.
                           4. `gcloud --project PROJECT_ID sql instances start INSTANCE_NAME`
                           EOT
  notification_channels  = [module.rackspace_urgent.notification_id]
  watchman_token         = var.watchman_token
  threshold              = 0.99
}

# module "mysql_replica_lag" {
#   source                 = "./modules/base-policy"
#   project_id             = var.project_id
#   combiner               = "AND"
#   policy_display_name    = "rax-amr-monitoring-mysql_replica_lag"
#   condition_display_name = "REPLICA LAG for MySQL INSTANCES (CSQL)"
#   condition_filter       = <<EOT
#                            metric.type="database/mysql/replication/seconds_behind_master" AND
#                            metadata.user_labels.monitored="true" AND
#                            resource.type="cloudsql_database"
#                            EOT
#   condition_duration     = "1200s"
#   runbook_content        = <<EOT
#                            1. Contact customer escalation or DBA team as appropriate 
#                               1. This metric relies heavily on the number of incomming updates to the master DB
#                            2. Consider upgrading the replica node type, troubleshooting, or enabling Parralell replication (5.7 + 8.0)
#                               1. https://cloud.google.com/sql/docs/mysql/replication/manage-replicas#configuring-parallel-replication
#                            2. https://cloud.google.com/sql/docs/mysql/replication/manage-replicas#troubleshooting
#                            3. `gcloud --project PROJECT_ID sql instances stop INSTANCE_NAME`
#                               3. `gcloud --project PROJECT_ID sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
#                                  - NOTE: see `gcloud sql instances set-machine-type --help` for more options.
#                               3. `gcloud --project PROJECT_ID sql instances start INSTANCE_NAME`
#                            EOT
#   notification_channels  = [module.mysql_replica_lag.rackspace_urgent_id]
#   watchman_token         = var.watchman_token
#   threshold              = 0
# }

### GKE Monitors

# module "k8s_node_cpu_util" {
#   source                 = "./modules/base-policy"
#   project_id             = var.project_id
#   combiner               = "AND"
#   policy_display_name    = "rax-amr-monitoring-k8s_node_cpu_util"
#   condition_display_name = "CPU UTILIZATOIN for K8S NODES "
#   condition_filter       = <<EOT
#                            metric.type="kubernetes.io/node/cpu/core_usage_time" AND
#                            metadata.user_labels.monitored="true" AND
#                            resource.type="k8s_node"
#                            EOT
#   condition_duration     = "900s"
#   runbook_content        = <<EOT
#                            1. Contact customer escalation or DBA team as appropriate 
#                               1. This metric relies heavily on the number of incomming updates to the master DB
#                            2. Consider upgrading the replica node type, troubleshooting, or enabling Parralell replication (5.7 + 8.0)
#                               1. https://cloud.google.com/sql/docs/mysql/replication/manage-replicas#configuring-parallel-replication
#                            2. https://cloud.google.com/sql/docs/mysql/replication/manage-replicas#troubleshooting
#                            3. `gcloud --project PROJECT_ID sql instances stop INSTANCE_NAME`
#                               3. `gcloud --project PROJECT_ID sql instances set-machine-type INSTANCE_NAME --machine-type MACHINE_TYPE`
#                                  - NOTE: see `gcloud sql instances set-machine-type --help` for more options.
#                               3. `gcloud --project PROJECT_ID sql instances start INSTANCE_NAME`
#                            EOT
#   notification_channels  = [module.k8s_node_cpu_util.rackspace_urgent_id]
#   watchman_token         = var.watchman_token
#   threshold              = 0.99
# }

## NGW Monitors

# module "ngw_allocation_failure" {
#   source                 = "./modules/base-policy"
#   project_id             = var.project_id
#   combiner               = "OR"
#   policy_display_name    = "rax-amr-nat_allocation_failed_emergency"
#   condition_display_name = "NAT Gateway Allocation Failure"
#   condition_filter       = <<EOT
#                            metric.type="router.googleapis.com/nat/nat_allocation_failed" 
#                            resource.type="nat_gateway"
#                            EOT
#   condition_duration     = "0s"
#   runbook_content        = <<EOT
#                            1. Increase `minPortsPerVm`
#                             1. See the [compute_router_nat](https://www.terraform.io/docs/providers/google/r/compute_router_nat.html) Terraform resource documentation for more information.
#                            EOT
#   notification_channels  = [module.ngw_allocation_failure.rackspace_urgent_id]
#   watchman_token         = var.watchman_token
#   threshold              = 1
# }

# module "ngw_port_exhaustion" {
#   source                 = "./modules/base-policy"
#   project_id             = var.project_id
#   combiner               = "OR"
#   policy_display_name    = "rax-amr-nat_gw_port_exhaustion"
#   condition_display_name = "NAT Gateway Port Exhaustion"
#   condition_filter       = <<EOT
#                            metric.type="router.googleapis.com/nat/allocated_ports" 
#                            resource.type="nat_gateway"
#                            EOT
#   condition_duration     = "60s"
#   runbook_content        = <<EOT
#                            1. Assign additional static address. Alternatively, investigate if minPortsPerVM can be reduced.
#                              1. See the [compute_router_nat](https://www.terraform.io/docs/providers/google/r/compute_router_nat.html) Terraform resource documentation for more information.
#                            2. Note: Alarm set @ 90% of 64512 which is the maximum number of ports that can be allocated to a single NAT address.
#                            EOT
#   notification_channels  = [module.ngw_port_exhaustion.rackspace_urgent_id]
#   watchman_token         = var.watchman_token
#   threshold              = 58060
# }
