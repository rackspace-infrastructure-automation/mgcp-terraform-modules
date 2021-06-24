resource "google_storage_bucket" "tf-bucket" {
  project       = var.project_id
  name          = "test-tf-bucket-backend"
  location      = "europe-west2"
  storage_class = "REGIONAL"
}