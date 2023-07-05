variable "project_id" {
  type = string
}

variable "watchman_token" {
  type = string
}

variable "runbook" {
  description = "Link to Customer Runbook"
  type        = map(string)
  default     = {}
}

variable "enabled" {
  description = "Enable notification channels"
  type = bool
  default = false
}

variable "default_runbook" {
  description = "Link to default Runbook"
  type        = map(string)
  default = {
    vm_disk             = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors"
    vm_cpu              = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors"
    vm_mem              = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors"
    uptime_check        = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Standard/RecommendedMonitors"
    nat_dropped_packet  = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)"
    nat_endpoint_map    = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)"
    nat_allocation_fail = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)"
    nat_port_exhaust    = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Networking(NAT)"
    csql_mem            = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Databases-CloudSQL(asperCustomerRequirement)"
    csql_cpu            = "https://one.rackspace.com/display/PCMS/GCP+Standard+Monitoring+-+Modern+Operations#GCPStandardMonitoring-ModernOperations-Databases-CloudSQL(asperCustomerRequirement)"
  }
}

variable "cpu_usage" {
  description = "CPU Utilisation Parameters"
  type = object({
    enabled       = optional(bool, false)
    cpu_threshold = optional(number, 0.95)
  })

  default = {}
}

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = optional(bool, false)
    mem_threshold = optional(number, 98)
  })

  default = {}
}

variable "uptime_check" {
  description = "Uptime Check Parameters"
  type = object({
    enabled = optional(bool, false)
  })

  default = {}
}


variable "disk_usage" {
  description = "Disk usage Parameters"
  type = object({
    enabled         = optional(bool, false)
    disk_percentage = optional(number, 10)
  })

  default = {}
}

variable "nat_alert" {
  description = "NAT Gateway Parameters"
  type = object({
    create_policy                   = optional(bool, false)
    enabled                         = optional(bool, false)
    threshold_value_dropped_packet  = optional(number, 0)
    threshold_value_allocated_ports = optional(number, 64512)
  })
  default = {}
}

variable "sql_alert" {
  description = "Cloud SQL Parameters"
  type = object({
    create_policy          = optional(bool, false)
    enabled                = optional(bool, false)
    threshold_value_memory = optional(number, 0.99)
    threshold_value_cpu    = optional(number, 0.99)
  })
  default = {}
}