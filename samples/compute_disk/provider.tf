provider "google" {
  project = var.project
  region  = "asia-southeast2"
  
  # For local testing, you can use Application Default Credentials or specify a service account key
  credentials = file("./sa.json")
}
