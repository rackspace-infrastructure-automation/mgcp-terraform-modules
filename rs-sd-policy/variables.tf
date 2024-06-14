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

variable "memory_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled       = bool
    mem_threshold = number
  })

  default = {
    enabled       = false
    mem_threshold = 100
  }
}


variable "disk_usage" {
  description = "Disk usage Parameters"
  type = object({
    enabled         = bool
    disk_percentage = number
  })

  default = {
    enabled         = false
    disk_percentage = 0
  }
}


variable "uptime_check" {
  description = "Uptime Check Parameters"
  type        = map(any)
}


variable "nat_alert" {
  description = "NAT Gateway Parameters"
  type        = map(any)
  default = {
    enabled = false
  }
}

variable "ssh_rdp_fw_alert" {
  description = "Insecure Firewall Rule Parameters"
  type        = map(any)
  default = {
    enabled = false
  }
}
