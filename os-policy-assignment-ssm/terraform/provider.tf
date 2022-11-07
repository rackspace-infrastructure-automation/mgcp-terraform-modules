terraform {
  required_version = "1.3.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.42.1"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.42.1"
    }
  }
  backend "gcs" {
    bucket = "test-tf-bucket-backend"
    prefix = "os-config-mgmt"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}