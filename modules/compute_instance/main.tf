#---------------------------------------------------
# Create compute instance
#---------------------------------------------------
resource "google_compute_instance" "compute_instance" {
  count = var.number_of_instances

  project      = var.project_name
  name         = "ce-${lower(var.name)}-${count.index + 1}"
  zone         = length(var.zones) > 0 ? var.zones[count.index] : var.zone
  machine_type = var.machine_type

  allow_stopping_for_update = var.allow_stopping_for_update
  can_ip_forward            = var.can_ip_forward
  description               = var.description
  deletion_protection       = var.deletion_protection
  min_cpu_platform          = var.min_cpu_platform

  timeouts {
    create = var.timeouts
    delete = var.timeouts
    update = var.timeouts
  }

  #scratch_disk {
  #    #interface   = "${var.scratch_disk_interface}"
  #}

  boot_disk {
    auto_delete             = var.boot_disk_auto_delete
    device_name             = var.boot_disk_device_name
    disk_encryption_key_raw = var.disk_encryption_key_raw
    initialize_params {
      size  = var.boot_disk_initialize_params_size
      type  = var.boot_disk_initialize_params_type
      image = var.boot_disk_initialize_params_image
    }
  }

  dynamic "attached_disk" {
    for_each = var.attached_disks
    content {
      source      = attached_disk.value.source
      device_name = attached_disk.value.device_name
      mode        = attached_disk.value.mode
    }
  }



  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = length(var.network_ips) > 0 ? var.network_ips[count.index] : null

    #alias_ip_range {
    #    ip_cidr_range              = "10.138.0.0/20"
    #    subnetwork_range_name      = ""
    #}

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {
        nat_ip                 = var.nat_ip
        public_ptr_domain_name = var.public_ptr_domain_name
        network_tier           = var.network_tier
      }
    }
  }

  labels = {
    name = "ce-${lower(var.name)}-${count.index + 1}"
  }

  tags = [
    "ce-${lower(var.name)}",
  ]

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  scheduling {
    preemptible         = var.scheduling_preemptible
    on_host_maintenance = var.scheduling_on_host_maintenance
    automatic_restart   = var.scheduling_automatic_restart
  }

  #Note: GPU accelerators can only be used with on_host_maintenance option set to TERMINATE.
  guest_accelerator {
    type  = var.guest_accelerator_type
    count = var.guest_accelerator_count
  }

  lifecycle {
    # ignore_changes = [
    #   "network_interface",
    # ]
    create_before_destroy = true
  }
}
