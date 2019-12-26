# rs-base-firewall

This module creates the Rackspace Firewall rules to allow ingress from Rackspace Bastions

```
module "rs_firewall" {
 source = "git@github.com:racker/mgcp-terraform-modules//rs-base-firewall/?ref=master"

 network_name = "network"

}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| network\_name | The name of the network. | string | null | yes |