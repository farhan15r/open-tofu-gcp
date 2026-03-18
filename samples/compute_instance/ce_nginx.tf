module "ce_nginx" {
  source              = "../../modules/compute_instance"
  number_of_instances = 1

  name         = "nginx"
  zones        = ["asia-southeast2-a"]
  machine_type = "e2-custom-2-4096"

  allow_stopping_for_update = false
  can_ip_forward            = false
  deletion_protection       = false

  boot_disk_initialize_params_size  = 21
  boot_disk_initialize_params_type  = "pd-standard"
  boot_disk_initialize_params_image = "rocky-linux-10-optimized-gcp"

  # attached_disks = [{
  #   source = "disk-existing-test"
  # }]

  network     = module.vpc_sample.google_compute_network_name[0]
  subnetwork  = module.subnet_development_vpc_sample.google_compute_subnetwork_name[0]
  network_ips = ["10.0.0.2"]

  enable_public_ip = true

  scheduling_preemptible       = true
  scheduling_automatic_restart = false
}

module "ce_haproxy" {
  source              = "../../modules/compute_instance"
  number_of_instances = 2

  name         = "haproxy"
  zones        = ["asia-southeast2-a", "asia-southeast2-b"]
  machine_type = "e2-custom-2-4096"

  allow_stopping_for_update = false
  can_ip_forward            = false
  deletion_protection       = false

  boot_disk_initialize_params_size  = 21
  boot_disk_initialize_params_type  = "pd-standard"
  boot_disk_initialize_params_image = "rocky-linux-10-optimized-gcp"

  # attached_disks = [{
  #   source = "disk-existing-test"
  # }]

  network     = module.vpc_sample.google_compute_network_name[0]
  subnetwork  = module.subnet_development_vpc_sample.google_compute_subnetwork_name[0]
  network_ips = ["10.0.0.10", "10.0.0.11"]

  enable_public_ip = true

  scheduling_preemptible       = true
  scheduling_automatic_restart = false
}

