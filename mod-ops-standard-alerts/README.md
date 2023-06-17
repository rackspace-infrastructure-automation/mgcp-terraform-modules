# rs-sd-policy

This module creates the Rackspace Standard Monitoring policies for Modern operations

Ref: https://one.rackspace.com/display/ModOps/GCP+Standard+Monitoring+-+Modern+Operations

```
module "rs_sd_policy" {
  source = "git@github.com:racker/mgcp-terraform-modules//mod-ops-standard-alerts/?ref=master"

  watchman_token = "00000000000"
  runbook = "This is link to runbook"

  enabled    = true
  project_id = var.project_id

  disk_usage = {
    enabled         = true
    disk_percentage = 10
  }

  memory_usage = {
    enabled       = false
    mem_threshold = 98
  }

  nat_alert = {
    enabled                         = true
    threshold_value_dropped_packet  = 5
    threshold_value_allocated_ports = 64512

  }

  uptime_check = {
    enabled = false
  }

  sql_alert = {
    enabled = true
    threshold_value_memory = 0.99
    threshold_value_cpu    = 0.99

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
| nat\_alert | NAT Gateway Parameters | <pre>object({<br>    enabled                         = bool<br>    threshold_value_dropped_packet  = number<br>    threshold_value_allocated_ports = number<br>  })| <pre>{<br>  "enabled": false,<br>  "threshold_value_dropped_packet": 0,<br>  "threshold_value_allocated_ports": 64512<br>}<br></pre> | no |
| sql\_alert | CSQL parameters | <pre>object({<br>    enabled                = bool<br>    threshold_value_memory = number<br>    threshold_value_cpu    = number <br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "threshold_value_memory": 0.99, <br>   "threshold_value_cpu": 0.99<br>}<br></pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| uptime\_check | Uptime Check Parameters |  <pre>object({<br>    enabled         = bool<br>   })<br></pre> | <pre>{<br>  "enabled": false,<br>}<br></pre> | no |
| watchman\_token | n/a | `string` | n/a | yes |
| runbook | Link to customer runbook | `string` | n/a | yes

## Outputs

No output.
