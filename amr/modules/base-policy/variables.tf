variable "project_id" {
  type = string
}

variable "watchman_token" {
  type = string
}

variable "policy_display_name" {
  type = string
}

variable "condition_display_name" {
  type = string
}

variable "condition_filter" {
  type = string
}

variable "condition_duration" {
  type = string
}

variable "runbook_content" {
  type = string
}

variable "notification_channels" {
  type    = list(string)
}

variable "enabled" {
  type = bool
}

variable "threshold_value" {
  type = number
  default = 0.9
}