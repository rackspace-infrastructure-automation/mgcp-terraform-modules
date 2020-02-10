# rs-sd-policy

This module creates the Rackspace Stackdriver Monitoring policies

```
module "rs_sd_policy" {
 source = "git@github.com:racker/mgcp-terraform-modules//rs-sd-policy/?ref=master"

 watchman_token = "00000000000"
 enabled = true
 project_id = "someproject"

rhel_disk_usage {
    enabled = true
    blk_dev_name = "sda1"
    disk_threshold_bytes = 10737418240
}

debian_disk_usage {
    enabled = true
    blk_dev_name = "root"
    disk_threshold_bytes = 10737418240
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

nat_alert {
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
| debian\_disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled              = bool<br>    blk_dev_name         = string<br>    disk_threshold_bytes = number<br>  })<br></pre> | <pre>{<br>  "blk_dev_name": "null",<br>  "disk_threshold_bytes": 0,<br>  "enabled": false<br>}<br></pre> | no |
| enabled | n/a | `bool` | `false` | no |
| memory\_usage | Memory Usage Parameters | <pre>object({<br>    enabled       = bool<br>    mem_threshold = number<br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "mem_threshold": 100<br>}<br></pre> | no |
| nat\_alert | Memory Usage Parameters | `map` | <pre>{<br>  "enabled": false<br>}<br></pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| rhel\_disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled              = bool<br>    blk_dev_name         = string<br>    disk_threshold_bytes = number<br>  })<br></pre> | <pre>{<br>  "blk_dev_name": "null",<br>  "disk_threshold_bytes": 0,<br>  "enabled": false<br>}<br></pre> | no |
| uptime\_check | Memory Usage Parameters | `map` | n/a | yes |
| watchman\_token | n/a | `string` | n/a | yes |
| windows\_disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled                   = bool<br>    blk_dev_name              = string<br>    disk_threshold_percentage = number<br>  })<br></pre> | <pre>{<br>  "blk_dev_name": "null",<br>  "disk_threshold_percentage": 80,<br>  "enabled": false<br>}<br></pre> | no |

## Outputs

No output.
