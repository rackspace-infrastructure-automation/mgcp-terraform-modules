# rs-sd-policy

This module creates the Rackspace Stackdriver Monitoring policies

Once these are deployed to the monitoring workspace, the customer should provide us with a custom notificaiton channel which we will ad manually to the alerts in the console.

```
module "rs_sd_policy" {
 source = "git@github.com:racker/mgcp-terraform-modules//optimizer-plus/optimizer-plus-sd-policy/?ref=master"

 enabled = true
 project_id = "someproject"

rhel_disk_usage {
    enabled = true
    blk_dev_name = "sda1"
    disk_threshold_percentage = 90
}

debian_disk_usage {
    enabled = true
    blk_dev_name = "root"
    disk_threshold_percentage = 90
}

windows_disk_usage {
    enabled = true
    blk_dev_name = "C:"
    disk_threshold_percentage = 90
}

memory_usage {
    enabled = true
    mem_threshold = 100
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
| debian\_disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled              = bool<br>    blk_dev_name         = string<br>    disk_threshold_bytes = number<br>  })<br></pre> | <pre>{<br>  "blk_dev_name": "null",<br>  "disk_threshold_bytes": 0,<br>  "enabled": false<br>}<br></pre> | no |
| enabled | n/a | `bool` | `false` | no |
| memory\_usage | Memory Usage Parameters | <pre>object({<br>    enabled       = bool<br>    mem_threshold = number<br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "mem_threshold": 100<br>}<br></pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| rhel\_disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled              = bool<br>    blk_dev_name         = string<br>    disk_threshold_bytes = number<br>  })<br></pre> | <pre>{<br>  "blk_dev_name": "null",<br>  "disk_threshold_bytes": 0,<br>  "enabled": false<br>}<br></pre> | no |
| uptime\_check | Memory Usage Parameters | `map` | n/a | yes |
| windows\_disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled                   = bool<br>    blk_dev_name              = string<br>    disk_threshold_percentage = number<br>  })<br></pre> | <pre>{<br>  "blk_dev_name": "null",<br>  "disk_threshold_percentage": 80,<br>  "enabled": false<br>}<br></pre> | no |

## Outputs

No output.
