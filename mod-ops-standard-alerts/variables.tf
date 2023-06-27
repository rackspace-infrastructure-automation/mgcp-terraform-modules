variable "project_id" {
  type = string
}

variable "watchman_token" {
  type = string
}

variable "enabled" {
  type    = bool
  default = false
}

variable "runbook" {
  description = "Link to Customer Runbook"
  type    = map
  default = {}
}

variable "default_runbook" {
  description = "Link to default Runbook"
  type    = map
  default = {
    vm_disk = "www.link_to_default_runbook_wiki_disk_section.com"
    vm_cpu  = "www.link_to_default_runbook_wiki_vm_cpu_usage_section.com"
    vm_mem  = "www.link_to_default_runbook_wiki_vm_mem_usage_section.com"
    uptime_check = "www.link_to_default_runbook_wiki_vm_uptime_check_section.com"
    nat_dropped_packet = "www.link_to_default_runbook_wiki_nat_dropped_packet_section.com"
    nat_endpoint_map = "www.link_to_default_runbook_wiki_nat_endpoint_map_section.com"
    nat_allocation_fail = "www.link_to_default_runbook_wiki_nat_allocation_fail_section.com"
    nat_port_exhaust = "www.link_to_default_runbook_wiki_nat_port_exhaust_section.com"
    csql_mem = "www.link_to_default_runbook_wiki_csql_mem_section.com"
    csql_cpu = "www.link_to_default_runbook_wiki_csql_cpu_section.com"
  }
}

variable "cpu_usage" {
  description = "CPU Utilisation Parameters"
  type = object({
    enabled       = optional(bool, false)
    cpu_threshold = optional(number, 0.95)
  })

  default = {
    enabled       = false
    cpu_threshold = 0.95
  }
}

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = optional(bool, false)
    mem_threshold = optional(number, 98)
  })

  default = {
    enabled              = false
    mem_threshold = 98
  }
}

variable "uptime_check" {
  description = "Uptime Check Parameters"
  type = object({
    enabled = optional(bool, false)
  })

  default = {
    enabled = false
  }
}


variable "disk_usage" {
  description = "Disk usage Parameters"
  type = object({
    enabled         = optional(bool, false)
    disk_percentage = optional(number, 10)
  })

  default = {
    enabled         = false
    disk_percentage = 10
  }
}

variable "nat_alert" {
  description = "NAT Gateway Parameters"
  type = object({
    create_policy                   = optional(bool, false)
    enabled                         = optional(bool, false)
    threshold_value_dropped_packet  = optional(number, 0)
    threshold_value_allocated_ports = optional(number, 64512)
  })
  default = {
    create_policy                   = false
    enabled                         = false
    threshold_value_dropped_packet  = 0
    threshold_value_allocated_ports = 64512
  }
}

variable "create_sql_policies" {
  description = "Create Cloud SQL policies"
  type = bool
  default = false
}

variable "sql_alert" {
  description = "Cloud SQL Parameters"
  type = object({
    create_policy          = optional(bool, false)
    enabled                = optional(bool, false)
    threshold_value_memory = optional(number, 0.99)
    threshold_value_cpu    = optional(number, 0.99)
  })
  default = {
    enabled                = false
    threshold_value_memory = 0.99
    threshold_value_cpu    = 0.99
  }
}