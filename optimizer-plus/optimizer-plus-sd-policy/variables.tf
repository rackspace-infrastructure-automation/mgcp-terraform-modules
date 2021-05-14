variable "project_id" {
  type = string
}

variable "enabled" {
  type    = bool
  default = false
}

variable "uptime_check" {
  description = "Uptime Check Parameters"
  type = object({
    enabled       = bool
    uptime_threshold   = number
  })

  default = {
    enabled       = false
    uptime_threshold   = 1
  }
}

variable "cpu_usage" {
  description = "CPU Usage Parameters"
  type = object({
    enabled       = bool
    cpu_threshold   = number
  })

  default = {
    enabled       = false
    cpu_threshold   = 0.9
  }
}

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = bool
    mem_threshold = number
  })

  default = {
    enabled       = false
    mem_threshold = 90
  }
}

variable "disk_usage" {
  description = "Disk Usage Parameters"
  type = object({
    enabled              = bool
    blk_dev_name         = string
    disk_threshold_percentage = number
  })

  default = {
    enabled                   = false
    blk_dev_name              = "null"
    disk_threshold_percentage = 80
  }
}
