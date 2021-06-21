variable "policy_display_name" {
  type = string
}

variable "combiner" {
  type = string
}

variable "condition_display_name" {
  type = string
}

variable "condition_filter" {
  type = string
}

variable "comparison" {
  type = string
  default = "COMPARISON_GT"
}

variable "condition_duration" {
  type = string
  default = "60s"
}

variable "runbook_content" {
  type = string
}

variable "notification_channels" {
  type = list(string)
}

variable "enabled" {
  type = bool
  default = true
}

variable "threshold" {
  type = number
  default = 0.9
}

variable "group_by_fields" {
  type = list(string)
  default = [
    "resource.label.project_id",
    "resource.label.zone",
    "resource.label.instance_id"
  ]
}

variable "alignment_period" {
  type = string
  default = "60s"
}

variable "per_series_aligner" {
  type = string
  default = "ALIGN_MEAN"
}

variable "cross_series_reducer" {
  type = string
  default = "REDUCE_MEAN"
}

variable "trigger_count" {
  type = number
  default = 1
}

variable "mime_type" {
  type = string
  default = "text/markdown"
}
