# rs-sd-policy

This module creates the Rackspace Stackdriver Monitoring policies

Once these are deployed to the monitoring workspace, the customer should provide us with a custom notificaiton channel which we will ad manually to the alerts in the console.

```
module "rs_sd_policy" {
 source = "git@github.com:racker/mgcp-terraform-modules//optimizer-plus/optimizer-plus-sd-policy/?ref=master"

 enabled = true
 project_id = "someproject"

disk_usage {
    enabled = true
    disk_threshold_percentage = 90
}

cpu_usage {
    enabled = true
    mem_threshold = 100
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
| enabled | n/a | `bool` | `false` | no |
| cpu\_usage | CPU Usage Parameters | <pre>object({<br>    enabled       = bool<br>    cpu_threshold = number<br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "cpu_threshold": 100<br>}<br></pre> | no |
| memory\_usage | Memory Usage Parameters | <pre>object({<br>    enabled       = bool<br>    mem_threshold = number<br>  })<br></pre> | <pre>{<br>  "enabled": false,<br>  "mem_threshold": 100<br>}<br></pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| uptime\_check | Memory Usage Parameters | `map` | n/a | yes |
| disk\_usage | Memory Usage Parameters | <pre>object({<br>    enabled                   = bool<br>    disk_threshold_percentage = number<br>  })<br></pre> | <pre>{<br>  "disk_threshold_percentage": 90,<br>  "enabled": false<br>}<br></pre> | no |

## Outputs

No output.
