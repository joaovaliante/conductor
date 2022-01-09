variable "instance_number" {
  type        = string
  description = "Instance number"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "n1-standard-32"
}

variable "instance_internal_ip" {
  type        = string
  description = "Internal IP"
  default     = null
}

variable "instance_ssh_keys" {
  type = list(object({
    user = string
    key  = string
  }))

  description = "List of User and Key"
}

variable "host_vpc_name" {
  type        = string
  description = "Descreve o nome da host vpc utilizada."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

variable "host_subnet_name" {
  type        = string
  description = "Descreve o nome da subnet da shared vpc utilizada."
}

variable "host_network_project" {
  type        = string
  description = "Descreve o nome da projeto host da shared vpc utilizada."
}

variable "zone" {
  type        = string
  default     = "us-east1-b"
  description = "Zone of instance."
}

variable "project" {
  type        = string
  description = "Project of instance."
}

variable "timezone" {
  type        = string
  description = "Timezone of Machines"
  default     = "UTC"
}

variable "disk_size_hot" {
  type        = number
  description = "Disk size on Hot"
  default     = 20
}

variable "disk_type_hot" {
  type        = string
  description = "Disk type on Hot"
  default     = "pd-balanced"
}

variable "disk_size_install" {
  type        = number
  description = "Disk size on Installation"
  default     = 20
}

variable "disk_type_install" {
  type        = string
  description = "Disk type on Installation"
  default     = "pd-balanced"
}

variable "disk_size_summary" {
  type        = number
  description = "Disk size on Summary"
  default     = null
}

variable "disk_type_summary" {
  type        = string
  description = "Disk type on Summary"
  default     = "pd-balanced"
}

variable "disk_size_cold" {
  type        = number
  description = "Disk size on Cold"
  default     = 20
}

variable "disk_type_cold" {
  type        = string
  description = "Disk type on Cold"
  default     = "pd-standard"
}

variable "labels" {
  type        = map(string)
  description = "Labels"
}