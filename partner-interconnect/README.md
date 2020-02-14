# gcp-partner-interconnect

This module creates a Partner Interconnect.

## Basic Usage

```
module "partner-interconnect" {
source = ../path/to//module

  vlans             = ["vlan-a", "vlan-b"]
  asn               = "16550"
  advertise_mode    = "CUSTOM"
  advertised_groups = ["ALL_SUBNETS"]

  network           = "<NETWORK>"
}
```


## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| advertise\_mode | Mode to use for advertisement. Valid values of this enum field are: DEFAULT, CUSTOM | `string` | `"DEFAULT"` | no |
| asn | Local BGP Autonomous System Number (ASN). Must be an RFC6996 private ASN | `string` | `"16550"` | no |
| network | The VPC network on which this router lives | `string` | n/a | yes |
| vlans | The list of vlan attachments being created | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bgp\_config | Cloud router BGP config |
| cloud\_router\_name | Cloud router name |
| interconnect\_pairing\_key | The identifier of a PARTNER attachment used to initiate provisioning with selected partner |
| interconnect\_vlan\_name | The VLAN attachment name |