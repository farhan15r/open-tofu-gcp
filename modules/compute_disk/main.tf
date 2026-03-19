#---------------------------------------------------
# Create compute disk
#---------------------------------------------------
resource "google_compute_disk" "compute_disk" {
  name        = "disk-${lower(var.name)}"
  description = var.description

  size  = var.size
  type  = var.type
  zone  = var.zone
  image = var.image

  dynamic "disk_encryption_key" {
    for_each = var.disk_encryption_key_raw_key != "" ? [1] : []
    content {
      raw_key = var.disk_encryption_key_raw_key
    }
  }

  dynamic "source_image_encryption_key" {
    for_each = var.source_image_encryption_key_raw_key != "" ? [1] : []
    content {
      raw_key = var.source_image_encryption_key_raw_key
    }
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }

  labels = {
    name = "disk-${lower(var.name)}"
  }

  lifecycle {
    ignore_changes        = []
    create_before_destroy = true
  }
}
