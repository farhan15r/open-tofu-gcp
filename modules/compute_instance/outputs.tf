########################################################################
# Compute instance
########################################################################
output "compute_instance_ids" {
  description = "The server-assigned unique identifier of this instance."
  value       = google_compute_instance.compute_instance.*.instance_id
}

output "compute_instance_metadata_fingerprints" {
  description = "The unique fingerprint of the metadata."
  value       = google_compute_instance.compute_instance.*.metadata_fingerprint
}

output "compute_instance_self_links" {
  description = "output the URI of the created resource."
  value       = google_compute_instance.compute_instance.*.self_link
}

output "compute_instance_tags_fingerprints" {
  description = "The unique fingerprint of the tags."
  value       = google_compute_instance.compute_instance.*.tags_fingerprint
}

output "compute_instance_label_fingerprints" {
  description = "The unique fingerprint of the labels."
  value       = google_compute_instance.compute_instance.*.label_fingerprint
}

output "compute_instance_cpu_platforms" {
  description = "The CPU platform used by this instance."
  value       = google_compute_instance.compute_instance.*.cpu_platform
}

output "compute_instance_internal_ip_addresses" {
  description = "The internal ip address of the instance, either manually or dynamically assigned."
  value       = google_compute_instance.compute_instance.*.network_interface.0.network_ip
}

output "compute_instance_external_ip_addresses" {
  description = "External IP addresses of the instances, null if private only."
  value = [
    for instance in google_compute_instance.compute_instance :
    try(instance.network_interface[0].access_config[0].nat_ip, null)
  ]
}
