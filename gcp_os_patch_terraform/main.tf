provider "google" {
    project                 = "mgcp-1224777-nebu-production"
    version                 = "~> 3.37"
}
 
module "os_patch_groups" {
    source                  = "./modules/01_ospatch_groups"
    deployment_id_1         = "blue-windows"
    deployment_id_2         = "blue-linux"
    deployment_id_3         = "green-windows"
    group_label_key         = "patch-group"
    group_label_value_1     = "blue-windows"
    group_label_value_2     = "blue-linux"
    group_label_value_3     = "green-windows"
    zone_id_filter          = ["europe-west4-a", "europe-west4-b", "europe-west4-c"]
    reboot_after_patch      = "ALWAYS"
    windows_update_class    = ["CRITICAL", "SECURITY"]
    windows_update_exclude  = []
    apt_update_type         = "DIST"
    apt_update_exclude      = ["python","bash"]
    yum_update_security     = true
    yum_update_minimal      = true
    yum_update_exclude      = ["python","bash"]
    script_bucket           = "auto_accept_eula"
    script_file             = "nebu-accept-eula-post-patch-script.sh"
    generation_number       = "1597761989020920"
    patch_window_duration   = "3600s"
    patch_time_zone         = "Europe/London"
    hours_1                 = 7
    hours_2                 = 7
    hours_3                 = 7
    minutes_1               = 30
    minutes_2               = 30
    minutes_3               = 0
    week_of_month           = 1
    day_of_week             = "SUNDAY"
}
 
terraform {
    required_version = "~> 0.13"
}