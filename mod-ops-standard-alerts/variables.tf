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
  type    = string
  default = "This section should include customer runbook"
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