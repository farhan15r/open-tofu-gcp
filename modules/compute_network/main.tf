#---------------------------------------------------
# Create compute network
#---------------------------------------------------
resource "google_compute_network" "compute_network" {
  count = var.enable_compute_network ? 1 : 0

  name        = "vpc-${lower(var.name)}"
  description = var.description
  project     = var.project

  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}
#---------------------------------------------------
# Create compute network peering
#---------------------------------------------------
resource "google_compute_network_peering" "compute_network_peering" {
  count = var.enable_compute_network_peering ? 1 : 0

  name         = "vpc-peering-${lower(var.name)}"
  network      = var.network
  peer_network = var.peer_network

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}
#---------------------------------------------------
# Create compute subnetwork
#---------------------------------------------------
resource "google_compute_subnetwork" "compute_subnetwork" {
  count = var.enable_compute_subnetwork ? 1 : 0

  name                     = "subnet-${lower(var.name)}-${lower(var.network)}"
  description              = var.description
  project                  = var.project
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = var.network
  private_ip_google_access = var.private_ip_google_access

  dynamic "log_config" {
    for_each = var.enable_flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 1
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}

#---------------------------------------------------
# Create google compute subnetwork iam policy
#---------------------------------------------------
data "google_iam_policy" "iam_policy" {
  binding {
    role    = var.role
    members = var.members
  }
}

resource "google_compute_subnetwork_iam_policy" "compute_subnetwork_iam_policy" {
  count = var.enable_compute_subnetwork_iam_policy ? 1 : 0

  project     = var.project
  region      = var.region
  subnetwork  = var.subnetwork
  policy_data = data.google_iam_policy.iam_policy.policy_data

  depends_on = [
    data.google_iam_policy.iam_policy
  ]

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}

#---------------------------------------------------
# Create google compute subnetwork iam binding
#---------------------------------------------------
resource "google_compute_subnetwork_iam_binding" "compute_subnetwork_iam_binding" {
  count = var.enable_compute_subnetwork_iam_binding ? 1 : 0

  project    = var.project
  region     = var.region
  subnetwork = var.subnetwork
  role       = var.role

  members = var.members

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}

#---------------------------------------------------
# Create google compute subnetwork iam member
#---------------------------------------------------
resource "google_compute_subnetwork_iam_member" "compute_subnetwork_iam_member" {
  count = var.enable_compute_subnetwork_iam_member ? 1 : 0

  project    = var.project
  region     = var.region
  subnetwork = var.subnetwork
  role       = var.role

  member = element(var.members, 0)

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}
