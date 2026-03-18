module "vpc_sample" {
  source                 = "../../modules/compute_network"
  enable_compute_network = true

  name   = "sample"
  region = "asia-southeast2"

  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

module "subnet_development_vpc_sample" {
  source                    = "../../modules/compute_network"
  enable_compute_subnetwork = true

  name                     = "development"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "asia-southeast2"
  network                  = module.vpc_sample.google_compute_network_name[0]
  private_ip_google_access = true
  enable_flow_logs         = false
}
