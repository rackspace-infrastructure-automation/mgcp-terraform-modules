variable "project_id" {
  description = "Project ID"
  type        = string
}
variable "region" {
  description = "Main region"
  type        = string
  default     = "europe-west2"
}

variable "excluded_instances" {
  description = "Add here instances excluded from monitoring"
  type        = list(string)
  default     = []
}

variable "vm_toggle_delay" {
  description = "List of instances to delay toggle monitoring in seconds"
  type        = string
  default     = "{}"
}

variable "toggle_delay" {
  description = "Toggle monitoring ON delay"
  type        = number
  default     = 0
}