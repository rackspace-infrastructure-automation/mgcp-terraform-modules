variable "project_id" {
  description = "Please type the project ID where the alert policies will be deployed"
  type        = string
}

variable "primary_email" {
  description = "Please type the primary email contact to be used as notification channel"
  type        = string
}

variable "enabled" {
  description = "Enable notification channels"
  type        = bool
  default     = true
}

variable "cpu_usage" {
  description = "CPU Utilisation Parameters"
  type = object({
    enabled       = optional(bool, true)
    cpu_threshold = optional(number, 0.95)
  })

  default = {}
}

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = optional(bool, true)
    mem_threshold = optional(number, 98)
  })

  default = {}
}

variable "uptime_check" {
  description = "Uptime Check Parameters"
  type = object({
    enabled = optional(bool, true)
  })

  default = {}
}


variable "disk_usage" {
  description = "Disk usage Parameters"
  type = object({
    enabled         = optional(bool, true)
    disk_percentage = optional(number, 10)
  })

  default = {}
}

variable "nat_alert" {
  description = "NAT Gateway Parameters"
  type = object({
    enabled                         = optional(bool, true)
    threshold_value_dropped_packet  = optional(number, 0)
    threshold_value_allocated_ports = optional(number, 64512)
  })
  default = {}
}

variable "sql_alert" {
  description = "Cloud SQL Parameters"
  type = object({
    enabled                = optional(bool, true)
    threshold_value_memory = optional(number, 0.99)
    threshold_value_cpu    = optional(number, 0.99)
  })
  default = {}
}

variable "deploy_nat_alerts" {
  type        = string
  description = "Deploy Cloud NAT alerts (if shared VPC for example)? Please type yes|no"
}

variable "deploy_sql_alerts" {
  type        = string
  description = "Deploy Cloud SQL alerts? Please type yes|no"
}
