# ha-vpn

This module creates a dynamic HA VPN (Beta)

For single tunnel dynamic VPNs or static VPNs, use this module: https://github.com/terraform-google-modules/terraform-google-vpn

```
module "ha-vpn" {
  source = "git@github.com:racker/mgcp-terraform-modules//ha-vpn?ref=master"

  network                   = "default"
  region                    = "europe-west2"
  cloud_router_name         = "vpn-rtr"
  gateway_name              = "some-gateway"
  resource_prefix           = "some-prefix"
  shared_secrets            = ["blah", "bleh"]
  peer_ips                  = ["1.1.1.1", "2.2.2.2"]
  peer_asn                  = 65002
  peer_remote_session_range = ["169.254.0.6", "169.254.1.6"]
  bgp_asn                   = 65001
  bgp_cr_session_range      = ["169.254.0.5/30", "169.254.1.5/30"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| network | The name of the network to use | string | - | yes |
| region | The region where the gateway and tunnels are going to be created | string | - | yes |
| gateway\_name | The name of the VPN gateway being created | string | - | yes |
| resource\_prefix | Prefices for tunnels, peer interfaces and peer sessions. | string | - | yes |
| advertised\_route\_priority | The priority of routes advertised to the BGP peers | number | 100 | no |
| bgp_cr_session\_range | Source IP and range of cloud router BGP session. A valid /30 subnet like 169.254.0.5/30 | list | - | yes |
| shared\_secrets | Shared secrets for the tunnels, dont forget to use KMS | string | - | yes |
| bgp\_asn | ASN of the Cloud Router | number | - | yes |
| peer\_asn | ASN of the peer VPN's router | number | - | yes |
| peer\_remote\_session\_range | Remote peer IP of cloud router BGP session. A valid ip in a /30 block like 169.254.0.6 | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_self\_link | The Selflink of the Gateway |
| gateway\_ips | The VPN Gateway Public IP |
