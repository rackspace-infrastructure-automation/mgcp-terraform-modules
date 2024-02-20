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
  type = list(string)
  default = []
}