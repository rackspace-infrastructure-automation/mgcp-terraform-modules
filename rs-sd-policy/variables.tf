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



variable "rhel_disk_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled              = bool
    blk_dev_name         = string
    disk_threshold_percentage = number
  })

  default = {
    enabled              = false
    blk_dev_name         = "null"
    disk_threshold_percentage = 80
  }
}

variable "debian_disk_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled              = bool
    blk_dev_name         = string
    disk_threshold_percentage = number
  })

  default = {
    enabled              = false
    blk_dev_name         = "null"
    disk_threshold_percentage = 80
  }
}

variable "windows_disk_usage" {
  description = "Memory Usage Parameters"
  type = object({
    enabled                   = bool
    blk_dev_name              = string
    disk_threshold_percentage = number
  })

  default = {
    enabled                   = false
    blk_dev_name              = "null"
    disk_threshold_percentage = 80
  }
}

variable "uptime_check" {
  description = "Memory Usage Parameters"
  type        = map
}


variable "nat_alert" {
  description = "Memory Usage Parameters"
  type        = map
  default = {
    enabled = false
  }
}