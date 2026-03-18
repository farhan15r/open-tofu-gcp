provider "google" {
  project     = var.project
  region      = "asia-southeast2"
  credentials = file("./sa.json")
}
