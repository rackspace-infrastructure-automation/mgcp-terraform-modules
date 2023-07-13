provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

terraform {
  required_version = "1.5.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.73.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.73.0"
    }
  }
}
