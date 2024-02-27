# Toggle Monitoring

This module creates 2 functions to toggle monitoring on/off when a VM is started/stopped by changing the "monitored" label

## Usage Example

module "toggle-monitoring" {
  source             = "github.com/rackspace-infrastructure-automation/mgcp-terraform-modules//toggle-monitoring"
  project_id         = var.project_id
  region             = var.region
  excluded_instances = ["instance-1", "instance-2"]
  toggle_delay = 30
  vm_toggle_delay = "{'instance-2':60, {'instance-2':120}}"
}

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | Project ID | `string` | n/a | yes |
| region | Region of the cloud functions (event triggers will be global) | `string` | n/a | yes |
| excluded_instances | List of instances to exclude from monitoring | `list(string)` | `[]` | no |
| toggle_delay | Delay in seconds to toggle monitoring on for all the VMs not listed in `vm_toggle_delay` (max 540 seconds) | `number` | `0` | no |
| vm_toggle_delay | Delay in seconds to toggle monitoring on for the VMs listed in `vm_toggle_delay` (max 540 seconds). The string will have to be typed in the python format as shown in the example above. | `string` | null | no |