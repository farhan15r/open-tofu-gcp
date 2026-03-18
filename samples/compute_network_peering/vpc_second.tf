module "vpc_second" {
  source                 = "../../modules/compute_network"
  enable_compute_network = true

  name   = "second"
  region = "asia-southeast2"

  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

module "subnet_production_vpc_second" {
  source                    = "../../modules/compute_network"
  enable_compute_subnetwork = true

  name                     = "production"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "asia-southeast2"
  network                  = module.vpc_second.google_compute_network_name[0]
  private_ip_google_access = true
  enable_flow_logs         = false
}

module "vpc_peering_second_to_first" {
  source                         = "../../modules/compute_network"
  enable_compute_network_peering = true

  name         = "second-to-first"
  network      = module.vpc_second.google_compute_network_self_link[0]
  peer_network = module.vpc_first.google_compute_network_self_link[0]
}
