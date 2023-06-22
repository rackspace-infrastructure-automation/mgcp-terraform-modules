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
    enabled       = bool
    cpu_threshold = optional(number)
  })

  default = {
    enabled       = false
    cpu_threshold = 0.95
  }
}

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = bool
    mem_threshold = optional(number)
  })

  default = {
    enabled              = false
    mem_threshold = 98
  }
}

variable "uptime_check" {
  description = "Uptime Check Parameters"
  type = object({
    enabled = bool
  })

  default = {
    enabled = false
  }
}


variable "disk_usage" {
  description = "Disk usage Parameters"
  type = object({
    enabled         = bool
    disk_percentage = optional(number)
  })

  default = {
    enabled         = false
    disk_percentage = 10
  }
}

variable "create_nat_policies" {
  description = "Create NAT policies"
  type = bool
  default = false
}

variable "nat_alert" {
  description = "NAT Gateway Parameters"
  type = object({
    enabled                         = bool
    threshold_value_dropped_packet  = optional(number)
    threshold_value_allocated_ports = optional(number)
  })
  default = {
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
    enabled                = bool
    threshold_value_memory = optional(number)
    threshold_value_cpu    = optional(number)
  })
  default = {
    enabled                = false
    threshold_value_memory = 0.99
    threshold_value_cpu    = 0.99
  }
}