# rs-sd-policy

This module creates the Rackspace OS Patch Configuration

```
module "rs_sd_policy" {
 source = "git@github.com:racker/mgcp-terraform-modules//os-patch-module/?ref=master"

 variable "deployment_id_1" {
    type        = string
    description = "Name of patch group"
}
 
variable "deployment_id_2" {
    type        = string
    description = "Name of patch group"
}
 
variable "deployment_id_3" {
    type        = string
    description = "Name of patch group"
}
 
variable "group_label_key" {
    type        = string
    description = "Key filter i.e. Windows / Linux / WebApp"
}
 
variable "group_label_value_1" {
    type        = string
    description = "Value filter i.e. red, blue, one, two, three, etc."
}
 
variable "group_label_value_2" {
    type        = string
    description = "Value filter i.e. red, blue, one, two, three, etc."
}
 
variable "group_label_value_3" {
    type        = string
    description = "Value filter i.e. red, blue, one, two, three, etc."
}
 
variable "zone_id_filter" {
    type        = list(string)
    default     = []
    description = "Zone filter list i.e. europe-west4-a, us-central-1c. Target VM instances in ANY of these zones empty = ALL."
}
 
variable "reboot_after_patch" {
    type        = string
    default     = "ALWAYS"
    description = "Post patch deployment reboot setting i.e. ALWAYS (recommended), DEFAULT (only if the patch / os requires it), NEVER."
}
 
variable "windows_update_class" {
    type        = list(string)
    default     = ["CRITICAL", "SECURITY", "UPDATE"]
    description = "If empty, all updates are applied."
}
 
variable "windows_update_exclude" {
    type        = list(string)
    description = "List of KBs to exclude from update."
}
 
variable "apt_update_type" {
    type        = string
    default     = "DIST"
    description = "Update type i.e. DIST or UPGRADE"
}
 
variable "apt_update_exclude" {
    type        = list(string)
    default     = ["CRITICAL", "SECURITY", "UPDATE"]
    description = "If empty, all updates are applied."
}
 
variable "yum_update_security" {
    type        = bool
    default     = true
    description = "Adds the --security flag to yum update. Not supported on all platforms."
}
 
variable "yum_update_minimal" {
    type        = bool
    default     = true
    description = "Will cause patch to run yum update-minimal instead."
}
 
variable "yum_update_exclude" {
    type        = list(string)
    description = "List of KBs to exclude from update."
}
 
variable "script_bucket" {
    type        = string
    description = "Bucket containing script"
}
 
variable "script_file" {
    type        = string
    description = "Script file"
}
 
variable "generation_number" {
    type        = string
    description = "Generation number of script object"
}
 
variable "patch_window_duration" {
    type        = string
    default     = "3600s"
    description = "The duration of the maintenance window allowed for this patch deployment i.e. must end with s i.e. 3600s"
}
 
variable "patch_time_zone" {
    type        = string
    default     = "Pacific/Auckland"
    description = "IANA Time Zone Database time zone, e.g. America/New_York Australia/Sydney"
}
 
variable "hours_1" {
    type        = string
    default     = 8
    description = "Hours of day in 24 hour format. Should be from 0 to 23."
}
 
variable "hours_2" {
    type        = string
    default     = 8
    description = "Hours of day in 24 hour format. Should be from 0 to 23."
}
 
variable "hours_3" {
    type        = string
    default     = 7
    description = "Hours of day in 24 hour format. Should be from 0 to 23."
}
 
variable "minutes_1" {
    type        = string
    default     = 0
    description = "Minutes of hour of day. Must be from 0 to 59."
}
 
variable "minutes_2" {
    type        = string
    default     = 0
    description = "Minutes of hour of day. Must be from 0 to 59."
}
 
variable "minutes_3" {
    type        = string
    default     = 0
    description = "Minutes of hour of day. Must be from 0 to 59."
}
 
variable "week_of_month" {
    type        = string
    default     = 1
    description = "Week number in a month. 1-4 indicates the 1st to 4th week of the month. -1 indicates the last week of the month."
}
 
variable "day_of_week" {
    type        = string
    default     = "SUNDAY"
    description = "Possible values are MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, and SUNDAY."
}

}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
|    source                  = STRING
|    deployment_id_1         = STRING
|    deployment_id_2         = STRING
|    deployment_id_3         = STRING
|    group_label_key         = STRING
|    group_label_value_1     = STRING
|    group_label_value_2     = STRING
|    group_label_value_3     = STRING
|    zone_id_filter          = LIST
|    reboot_after_patch      = STRING
|    windows_update_class    = LIST
|    windows_update_exclude  = LIST
|    apt_update_type         = STRING
|    apt_update_exclude      = LIST
|    yum_update_security     = BOOL
|    yum_update_minimal      = BOOL
|    yum_update_exclude      = LIST
|    script_bucket           = "STRING
|    script_file             = STRING
|    generation_number       = STRING
|    patch_window_duration   = STRING
|    patch_time_zone         = STRING
|    hours_1                 = STRING
|    hours_2                 = STRING
|    hours_3                 = STRING
|    minutes_1               = STRING
|    minutes_2               = STRING
|    minutes_3               = STRING
|    week_of_month           = STRING
|    day_of_week             = STRING

## Outputs

No output.
