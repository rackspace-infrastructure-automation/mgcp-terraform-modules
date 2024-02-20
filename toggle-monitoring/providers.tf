terraform {
  required_version = "1.7.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.16"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.16"
    }
  }
  backend "gcs" {
    bucket = "tf-bucket-backend"
    prefix = "toggle-monitoring"
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