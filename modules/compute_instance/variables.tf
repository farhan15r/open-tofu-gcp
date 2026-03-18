variable "name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  default     = "TEST"
}

variable "zone" {
  description = "The zone that the machine should be created in"
  default     = "us-east1-b"
}

variable "zones" {
  description = "If number_of_instances > 1 and want separate zone for each instance, provide list of zones"
  default     = []

  validation {
    condition     = length(var.zones) == var.number_of_instances || length(var.zones) == 0
    error_message = "The number of zones must be equal to the number of instances or 0 (auto-assign)"
  }
}

variable "project_name" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = ""
}

variable "machine_type" {
  description = "The machine type to create"
  default     = "e2-micro"
}

variable "allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail"
  default     = true
}

variable "can_ip_forward" {
  description = "Whether to allow sending and receiving of packets with non-matching source or destination IPs. This defaults to false."
  default     = false
}

variable "timeouts" {
  description = "Configurable timeout in minutes for creating instances. Default is 4 minutes. Changing this forces a new resource to be created."
  default     = "10m"
}

variable "description" {
  description = "A brief description of this resource."
  default     = ""
}

variable "deletion_protection" {
  description = "Enable deletion protection on this instance. Defaults to false. Note: you must disable deletion protection before removing the resource (e.g., via terraform destroy), or the instance cannot be deleted and the Terraform run will not complete successfully."
  default     = false
}

variable "min_cpu_platform" {
  description = "Specifies a minimum CPU platform for the VM instance. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. Note: allow_stopping_for_update must be set to true in order to update this field."
  default     = ""
}

variable "boot_disk_auto_delete" {
  description = "Whether the disk will be auto-deleted when the instance is deleted. Defaults to true."
  default     = true
}

variable "boot_disk_device_name" {
  description = "Name with which attached disk will be accessible under /dev/disk/by-id/"
  default     = ""
}

variable "disk_encryption_key_raw" {
  description = "A 256-bit customer-supplied encryption key, encoded in RFC 4648 base64 to encrypt this disk."
  default     = ""
}

variable "boot_disk_initialize_params_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = number
  default     = 10
}

variable "boot_disk_initialize_params_type" {
  description = "The GCE disk type. May be set to pd-standard or pd-ssd."
  type        = string
  default     = "pd-standard"
}

variable "boot_disk_initialize_params_image" {
  description = "The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. If referred by family, the images names must include the family name. If they don't, use the google_compute_image data source. For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here."
  default     = "debian-13-trixie"
}

variable "attached_disks" {
  description = "List of disks to attach to the instance"
  type = list(object({
    source      = string
    device_name = optional(string)
    mode        = optional(string)
  }))
  default = []

  validation {
    condition     = !(length(var.attached_disks) != 0 && var.number_of_instances > 1)
    error_message = "attached_disks must be empty if number_of_instances is greater than 1 [currently not suport, must update this module] consider to use NFS"
  }
}

variable "number_of_instances" {
  description = "Number of instances to make"
  default     = 1
}


variable "network" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided."
  default     = "default"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = ""
}

variable "subnetwork_project" {
  description = "The project in which the subnetwork belongs. If the subnetwork is a self_link, this field is ignored in favor of the project defined in the subnetwork self_link. If the subnetwork is a name and this field is not provided, the provider project is used."
  default     = ""
}

variable "network_ips" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.network_ips) == var.number_of_instances || length(var.network_ips) == 0
    error_message = "The number of network_ips must be equal to the number of instances or 0 (auto-assign)"
  }
}

variable "enable_public_ip" {
  description = "Enable public IP for the instance"
  type        = bool
  default     = false
}

variable "nat_ip" {
  description = "The IP address that will be 1:1 mapped to the instance's network ip. If not given, one will be generated."
  default     = ""
}

variable "public_ptr_domain_name" {
  description = "The DNS domain name for the public PTR record. To set this field on an instance, you must be verified as the owner of the domain."
  default     = ""
}

variable "network_tier" {
  description = "The networking tier used for configuring this instance. This field can take the following values: PREMIUM or STANDARD. If this field is not specified, it is assumed to be PREMIUM."
  default     = "PREMIUM"
}

variable "service_account_email" {
  description = "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true in order to update this field."
  default     = ""
}

variable "service_account_scopes" {
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. Note: allow_stopping_for_update must be set to true in order to update this field."
  default     = []
}

variable "scheduling_preemptible" {
  description = "Is the instance preemptible."
  default     = false
}

variable "scheduling_on_host_maintenance" {
  description = "Describes maintenance behavior for the instance. Can be MIGRATE or TERMINATE"
  default     = "TERMINATE"
}

variable "scheduling_automatic_restart" {
  description = "Specifies if the instance should be restarted if it was terminated by Compute Engine (not a user)."
  default     = true
}

variable "guest_accelerator_type" {
  description = "The accelerator type resource to expose to this instance. E.g. nvidia-tesla-k80."
  default     = ""
}

variable "guest_accelerator_count" {
  description = "The number of the guest accelerator cards exposed to this instance."
  default     = 0
}
