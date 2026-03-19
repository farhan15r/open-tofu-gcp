module "disk_nginx_data" {
  source = "../../modules/compute_disk"

  name = "nginx-data"

  size = 10
  type = "pd-standard"
  zone = "asia-southeast2-a"
}
