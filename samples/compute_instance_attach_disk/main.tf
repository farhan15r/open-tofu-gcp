module "disk_data" {
  source = "../../modules/compute_disk"

  name = "data-disk"

  size = 10
  type = "pd-standard"
  zone = "asia-southeast2-a"
}

module "ce_nginx" {
  source              = "../../modules/compute_instance"
  number_of_instances = 1

  name         = "nginx-with-disk"
  zones        = ["asia-southeast2-a"]
  machine_type = "e2-custom-2-4096"

  allow_stopping_for_update = false
  can_ip_forward            = false
  deletion_protection       = false

  boot_disk_initialize_params_size  = 21
  boot_disk_initialize_params_type  = "pd-standard"
  boot_disk_initialize_params_image = "rocky-linux-10-optimized-gcp"

  attached_disks = [{
    source = module.disk_data.self_link[0]
  }]

  network     = module.vpc_sample.google_compute_network_name[0]
  subnetwork  = module.subnet_development_vpc_sample.google_compute_subnetwork_name[0]
  network_ips = ["10.0.0.5"]

  enable_public_ip = true

  scheduling_preemptible       = true
  scheduling_automatic_restart = false
}
