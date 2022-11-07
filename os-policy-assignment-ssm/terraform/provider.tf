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
    bucket = "BACKEND_BUCKET"
    prefix = "BUCKET_FOLDER"
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