# mod-ops-standard-alerts

This module creates the Rackspace Standard Monitoring policies for Modern operations

Ref: https://one.rackspace.com/display/ModOps/GCP+Standard+Monitoring+-+Modern+Operations


## Usage example
```
module "rs_sd_policy" {
  source         = "github.com/rackspace-infrastructure-automation/mgcp-terraform-modules//mod-ops-standard-alerts"
  project_id     = var.project_id
  watchman_token = "000000000000000000000"
  nat_alert = {
    create_policy = true
  }
  sql_alert = {
    enabled        = true
    create_policy = true
  }
  disk_usage = {
    enabled = true
  }
  cpu_usage = {
    enabled = true
  }
  memory_usage = {
    enabled = true
  }
  uptime_check = {
    enabled = true
  }
}
```

## Providers
| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| disk\_usage | Disk usage parameters | <pre>object({<br>    enabled         = bool<br>    disk_percentage = number<br>  })<br></pre> | <pre>{<br>  "disk_percentage": 10,<br>  "enabled": false<br>}<br></pre> | no |
| memory\_usage | Memory Usage Parameters | <pre>object({<br>    enabled       = bool<br>    mem_threshold = number <br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "mem_threshold": 98<br>}<br></pre> | no |
| nat\_alert | NAT Gateway Parameters | <pre>object({<br>    create_policy                   = bool<br>    enabled                         = bool<br>    threshold_value_dropped_packet  = number<br>    threshold_value_allocated_ports = number<br>  })| <pre>{<br>  "create_policy: false,<br>  "enabled": false,<br>  "threshold_value_dropped_packet": 0,<br>  "threshold_value_allocated_ports": 64512<br>}<br></pre> | no |
| sql\_alert | CSQL parameters | <pre>object({<br>    create_policy          = bool<br>    enabled                = bool<br>    threshold_value_memory = number<br>    threshold_value_cpu    = number <br>  })<br></pre> | <pre>{<br>  "create_policy": false,<br>  "enabled": false,<br>  "threshold_value_memory": 0.99, <br>  "threshold_value_cpu": 0.99<br>}<br></pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| uptime\_check | Uptime Check Parameters |  <pre>object({<br>    enabled         = bool<br>   })<br></pre> | <pre>{<br>  "enabled": false,<br>}<br></pre> | no |
| watchman\_token | n/a | `string` | n/a | yes |
| runbook | Links to customer runbook | <pre>object({<br>    vm_disk             = string<br>    vm_cpu              = string<br>    vm_mem              = string<br>    uptime_check        = string<br>    nat_dropped_packet  = string<br>    nat_endpoint_map    = string<br>    nat_allocation_fail = string<br>    nat_port_exhaust    = string<br>    csql_mem            = string<br>    csql_cpu            = string<br>  })<br></pre> | <pre>{<br>  "vm_disk": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors",<br>  "vm_cpu": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors",<br>  "vm_mem": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors",<br>  "uptime_check": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors",<br>  "nat_dropped_packet": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)",<br>  "nat_endpoint_map": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)",<br>  "nat_allocation_fail": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)",<br>  "nat_port_exhaust": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)",<br>  "csql_mem": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Databases-CloudSQL(asperCustomerRequirement)",<br>  "csql_cpu": "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Databases-CloudSQL(asperCustomerRequirement)",<br>}<br></pre> | no
| enabled | Enable notification channels | `bool` | false | no
| disk_filters  | Allow the addition of extra filters for disk policy | `string` | "" | no |
| cpu_filters  | Allow the addition of extra filters for cpu policy | `string` | "" | no |
| mem_filters  | Allow the addition of extra filters for memory policy | `string` | "" | no |

## Outputs

No output.

## CPU, Disk and MEM filter usage
1. All filters must start with `AND`. Example: `"AND resource.labels.instance_id != \"755424311712857499\""`
1. Make sure to add `AND` between one filter and another. Example: `"AND resource.labels.instance_id != \"755424311712857499\" AND project = \"ops-leonardo-bertini\""`
1. Use `\"` to type double quotes within the string