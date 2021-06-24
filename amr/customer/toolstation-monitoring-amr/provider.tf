provider "google" {
  project = var.project_id
}

terraform {
  required_version = ">=0.12.0"
  required_providers {
    google = {
      version = ">=3.37.0"
    }
  }
  backend "gcs" {
    bucket      = "test-tf-bucket-backend"
    prefix      = "ops-leonardo-bertini"
  }
}