module "vpc_first" {
  source                 = "../../modules/compute_network"
  enable_compute_network = true

  name   = "first"
  region = "asia-southeast2"

  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

module "subnet_development_vpc_first" {
  source                    = "../../modules/compute_network"
  enable_compute_subnetwork = true

  name                     = "development"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "asia-southeast2"
  network                  = module.vpc_first.google_compute_network_name[0]
  private_ip_google_access = true
  enable_flow_logs         = false
}

module "vpc_peering_first_to_second" {
  source                         = "../../modules/compute_network"
  enable_compute_network_peering = true

  name         = "first-to-second"
  network      = module.vpc_first.google_compute_network_self_link[0]
  peer_network = module.vpc_second.google_compute_network_self_link[0]
}
