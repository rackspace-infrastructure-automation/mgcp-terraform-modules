# Interconnect details
variable "interconnect_name" {
    description   = "Interconnect Name"
    type          = "string"
    default       = "test-vlan"
}

variable "interconnect_type" {
    description   = "Interconnect Type"
    type          = "string"
    default       = "PARTNER"
}

variable "interconnect_count" {
    description   = "Number of Interconnect Attachments"
    type          = "string"
    default       = "2"
}


# Router details
variable "interconnect_router" {
    description   = "Interconnect Router Name"
    type          = "string"
    default       = "test-router"
}