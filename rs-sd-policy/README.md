# rs-sd-policy

This module creates the Rackspace Stackdriver Monitoring policies

```
module "rs_sd_policy" {
  source = "git@github.com:racker/mgcp-terraform-modules//rs-sd-policy/?ref=master"

  watchman_token = "00000000000"
  enabled = true
  project_id = "someproject"

  disk_usage = {
    enabled         = true
    disk_percentage = 90
  }

  memory_usage = {
    enabled = true
    mem_threshold = 100
  }

  uptime_check = {
    enabled = true
  }

### Shared VPC Alert Policies ###

  nat_alert = {
    enabled = false
  }

  ssh_rdp_fw_alert = {
    enabled = false
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
| disk\_usage | Disk usage parameters | <pre>object({<br>    enabled         = bool<br>    disk_percentage = number<br>  })<br></pre> | <pre>{<br>  "disk_percentage": 90,<br>  "enabled": false<br>}<br></pre> | no |
| memory\_usage | Memory Usage Parameters | <pre>object({<br>    enabled       = bool<br>    mem_threshold = number<br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "mem_threshold": 100<br>}<br></pre> | no |
| nat\_alert | NAT Gateway Parameters | `map` | <pre>{<br>  "enabled": false<br>}<br></pre> | no |
| ssh\_rdp\_fw\_alert | Insecure Firewall Rule Parameters | `map` | <pre>{<br>  "enabled": false<br>}<br></pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| uptime\_check | Uptime Check Parameters | `map` | n/a | yes |
| watchman\_token | n/a | `string` | n/a | yes |

## Outputs

No output.
