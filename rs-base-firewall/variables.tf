variable "rax_ranges" {
  type = list
  default = [

    "134.213.179.10",  # support.lon3.gateway.rackspace.com
    "172.99.99.10",    # support.dfw1.gateway.rackspace.com
    "161.47.0.10",     # support.ord1.gateway.rackspace.com
    "146.20.2.10",     # support.iad3.gateway.rackspace.com
    "134.213.178.10",  # support.lon5.gateway.rackspace.com
    "119.9.122.10",    # support.hkg1.gateway.rackspace.com
    "119.9.148.10",    # support.syd2.gateway.rackspace.com
    "72.3.186.100",    # pbast.dfw1.corp.rackspace.net
    "134.213.183.100", # pbast.lon3.corp.rackspace.net
    "146.20.30.100",   # pbast.iad3.corp.rackspace.net
    "161.47.6.100",    # pbast.ord1.corp.rackspace.net
    "134.213.182.100", # pbast.lon5.corp.rackspace.net
    "120.136.39.100",  # pbast.hkg1.corp.rackspace.net
    "119.9.163.100"    # pbast.syd2.corp.rackspace.net
  ]
}

variable "network_name" {
  type = string
}

