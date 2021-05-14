variable "project_id" {
  type = string
}

variable "uptime_check" {
  description = "Uptime Check Parameters"
  type = object({
    enabled       = bool
    duration      = string
  })
}

variable "cpu_usage" {
  description = "CPU Usage Parameters"
  type = object({
    enabled        = bool
    cpu_threshold  = number
  })
}

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = bool
    mem_threshold = number
  })
}

variable "disk_usage" {
  description = "Disk Usage Parameters"
  type = object({
    enabled         = bool
    blk_dev_name    = string
    threshold_value = number
  })
}
