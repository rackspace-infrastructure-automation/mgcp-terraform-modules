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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| watchman\_token | Watchman Token | string | `""` | yes |
| project_id | Project ID | string | `""` | yes |
| enabled | Are the notification channels enabled? | bool | false | no |
| rhel_disk_usage | RHEL Disk Parameters | object | `<map>` | no |
| debian_disk_usage | Debian Disk Parameters | object | `<map>` | no |
| windows_disk_usage | Windows Disk Parameters | object | `<map>` | no |
| memory_usage | Memory Usage Parameters | object | `<map>` | no |
| nat_alert | NAT GW Parameters | map | `<map>` | no |