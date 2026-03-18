module "vpc_central" {
  source                 = "../../modules/compute_network"
  enable_compute_network = true

  name   = "central"
  region = "asia-southeast2"

  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

module "subnet_development_vpc_central" {
  source                    = "../../modules/compute_network"
  enable_compute_subnetwork = true

  name                     = "development"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "asia-southeast2"
  network                  = module.vpc_central.google_compute_network_name[0]
  private_ip_google_access = true
  enable_flow_logs         = false

  secondary_ip_ranges = [
    {
      range_name    = "k8s-pods-1"
      ip_cidr_range = "10.200.0.0/20"
    },
    {
      range_name    = "k8s-pods-2"
      ip_cidr_range = "10.200.16.0/20"
    }
  ]
}
