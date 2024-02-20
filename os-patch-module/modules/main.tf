### Example Usage ###

provider "google" {
  version = "=>3.37.0"
}

terraform {
  required_version = "=>0.13.2"
}

module "os_patch_config" {
  source                 = "git@github.com:racker/mgcp-terraform-modules/os-patch-module/?ref=master"
  deployment_id_1        = "blue-windows"
  deployment_id_2        = "blue-linux"
  deployment_id_3        = "green-windows"
  group_label_key        = "patch-group"
  group_label_value_1    = "blue-windows"
  group_label_value_2    = "blue-linux"
  group_label_value_3    = "green-windows"
  zone_id_filter         = ["europe-west4-a", "europe-west4-b", "europe-west4-c"]
  reboot_after_patch     = "ALWAYS"
  windows_update_class   = ["CRITICAL", "SECURITY"]
  windows_update_exclude = []
  apt_update_type        = "DIST"
  apt_update_exclude     = ["python", "bash"]
  yum_update_security    = true
  yum_update_minimal     = true
  yum_update_exclude     = ["python", "bash"]
  script_bucket          = "some_bucket"
  script_file            = "some_script.sh"
  generation_number      = "some_number"
  patch_window_duration  = "3600s"
  patch_time_zone        = "Europe/London"
  hours_1                = 7
  hours_2                = 7
  hours_3                = 7
  minutes_1              = 30
  minutes_2              = 30
  minutes_3              = 0
  week_of_month          = 1
  day_of_week            = "SUNDAY"
}