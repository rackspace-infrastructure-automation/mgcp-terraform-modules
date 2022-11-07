variable "exclusion_label" {
  type = object({
    key   = string
    value = string
  })
  description = "Label used to exclude the policy"
}
variable "zone" {
  type        = string
  description = "Zone"
}

variable "name" {
  type        = string
  description = "Name of the resource"
}