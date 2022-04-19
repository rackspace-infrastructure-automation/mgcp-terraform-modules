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

variable "content_emergency" {
  type = string
}

variable "content_urgent" {
  type = string
}

variable "prod_project" {
  type = string
}
