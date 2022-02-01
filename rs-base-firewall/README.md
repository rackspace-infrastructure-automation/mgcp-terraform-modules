# rs-base-firewall

This module creates the Rackspace Firewall rules to allow ingress from Rackspace Bastions

```
module "rs_firewall" {
 source = "git@github.com:racker/mgcp-terraform-modules//rs-base-firewall/?ref=master"

 network_name = "network"

}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| network\_name | n/a | `string` | n/a | yes |
| rax\_ranges | n/a | `list` | <pre>[<br>  "134.213.179.10",<br>  "172.99.99.10",<br>  "161.47.0.10",<br>  "146.20.2.10",<br>  "134.213.178.10",<br>  "119.9.122.10",<br>  "119.9.148.10",<br>  "72.3.186.100",<br>  "134.213.183.100",<br>  "146.20.30.100",<br>  "161.47.6.100",<br>  "134.213.182.100",<br>  "120.136.39.100",<br>  "119.9.163.100"<br>]<br></pre> | no |
| rule\_prefix | n/a | `string` | `""` | no |
| disabled | Disable the rs base firewalls | `bool` | `false` | no |

## Outputs

No output.