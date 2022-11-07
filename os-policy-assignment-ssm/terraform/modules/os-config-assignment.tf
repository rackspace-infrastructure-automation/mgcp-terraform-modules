resource "google_os_config_os_policy_assignment" "ssm-policy" {
  instance_filter {
    all = false
    exclusion_labels {
      labels = {
        (var.exclusion_label).key = (var.exclusion_label).value
      }
    }
  }

  location = var.zone
  name     = var.name

  os_policies {
    id   = "ssm-policy"
    mode = "ENFORCEMENT"
    resource_groups {
      inventory_filters {
        os_short_name = "debian"
      }
      resources {
        id = "install-ssm-debian"
        exec {
          validate {
            interpreter = "SHELL"
            script      = "if systemctl is-active --quiet amazon-ssm-agent; then exit 100; else exit 101; fi"
          }
          enforce {
            interpreter = "SHELL"
            script      = "curl https://add-ons.manage.rackspace.com/bootstrap/gcp/install.sh | bash && exit 100"
          }
        }
      }
    }
    resource_groups {
      inventory_filters {
        os_short_name = "centos"
      }
      resources {
        id = "install-ssm-centos"
        exec {
          validate {
            interpreter = "SHELL"
            script      = "if systemctl is-active --quiet amazon-ssm-agent; then exit 100; else exit 101; fi"
          }
          enforce {
            interpreter = "SHELL"
            script      = "curl https://add-ons.manage.rackspace.com/bootstrap/gcp/install.sh | bash && exit 100"
          }
        }
      }
    }
    resource_groups {
      inventory_filters {
        os_short_name = "ubuntu"
      }
      resources {
        id = "install-ssm-ubuntu"
        exec {
          validate {
            interpreter = "SHELL"
            script      = "if systemctl is-active --quiet amazon-ssm-agent; then exit 100; else exit 101; fi"
          }
          enforce {
            interpreter = "SHELL"
            script      = "curl https://add-ons.manage.rackspace.com/bootstrap/gcp/install.sh | bash && exit 100"
          }
        }
      }
    }
    resource_groups {
      inventory_filters {
        os_short_name = "windows"
      }
      resources {
        id = "install-ssm-windows"
        exec {
          validate {
            interpreter = "POWERSHELL"
            script      = <<EOT
                $service = Get-Service -Name 'AmazonSSMAgent'
                if ($service.Status -eq 'Running') {exit 100} else {exit 101}
            EOT
          }
          enforce {
            interpreter = "POWERSHELL"
            script      = <<EOT
                $SSMscript = Invoke-WebRequest -Uri "https://add-ons.manage.rackspace.com/bootstrap/gcp/gcp_bootstrap_ssm.ps1" -UseBasicParsing
                Invoke-Expression -Command $SSMscript
                exit 100
            EOT
          }
        }
      }
    }
  }
  rollout {
    disruption_budget {
      percent = 100
    }
    min_wait_duration = "300s"
  }
}