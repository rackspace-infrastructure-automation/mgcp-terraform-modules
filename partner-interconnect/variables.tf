variable "vlans" {
  type        = list(string)
  description = "The list of vlan attachments being created"
}
variable "network" {
  type        = string
  description = "The VPC network on which this router lives"
}

variable "asn" {
  type        = string
  description = "Local BGP Autonomous System Number (ASN). Must be an RFC6996 private ASN"
  default     = "16550"
}

variable "advertise_mode" {
  type        = string
  description = "Mode to use for advertisement. Valid values of this enum field are: DEFAULT, CUSTOM"
  default     = "DEFAULT"
}
