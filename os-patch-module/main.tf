resource "google_os_config_patch_deployment" "blue-windows" {
  patch_deployment_id = var.deployment_id_1
 
 
  instance_filter {
    group_labels {
      labels = {
        (var.group_label_key) = (var.group_label_value_1)
      }
    }
 
    zones = var.zone_id_filter
  }
 
  patch_config {
    reboot_config = var.reboot_after_patch
 
    windows_update {
      classifications = var.windows_update_class
      excludes = var.windows_update_exclude
    }
  }
 
  duration = var.patch_window_duration
 
  recurring_schedule {
    time_zone {
      id = var.patch_time_zone
    }
 
    time_of_day {
      hours = var.hours_1
      minutes = var.minutes_1
    }
 
    monthly {
      week_day_of_month {
        week_ordinal = var.week_of_month
        day_of_week  = var.day_of_week
      }
    }
  }
}
 
resource "google_os_config_patch_deployment" "blue-linux" {
  patch_deployment_id = var.deployment_id_2
 
  instance_filter {
    group_labels {
      labels = {
        (var.group_label_key) = (var.group_label_value_2)
      }
    }
 
    zones = var.zone_id_filter
  }
 
  patch_config {
    reboot_config = var.reboot_after_patch
 
    apt {
      type = var.apt_update_type
      excludes = var.apt_update_exclude
    }
 
    post_step {
    linux_exec_step_config {
      gcs_object {
        bucket = var.script_bucket
        object = var.script_file
        generation_number = var.generation_number
        }
      }
    }
  }
 
  duration = var.patch_window_duration
 
  recurring_schedule {
    time_zone {
      id = var.patch_time_zone
    }
 
    time_of_day {
      hours = var.hours_2
      minutes = var.minutes_2
    }
 
    monthly {
      week_day_of_month {
        week_ordinal = var.week_of_month
        day_of_week  = var.day_of_week
      }
    }
  }
}
 
resource "google_os_config_patch_deployment" "green-windows" {
  patch_deployment_id = var.deployment_id_3
 
  instance_filter {
    group_labels {
      labels = {
        (var.group_label_key) = (var.group_label_value_3)
      }
    }
 
    zones = var.zone_id_filter
  }
 
  patch_config {
    reboot_config = var.reboot_after_patch
 
    windows_update {
      classifications = var.windows_update_class
      excludes = var.windows_update_exclude
    }
  }
 
  duration = var.patch_window_duration
 
  recurring_schedule {
    time_zone {
      id = var.patch_time_zone
    }
 
    time_of_day {
      hours = var.hours_3
      minutes = var.minutes_3
    }
 
    monthly {
      week_day_of_month {
        week_ordinal = var.week_of_month
        day_of_week  = var.day_of_week
      }
    }
  }
}
