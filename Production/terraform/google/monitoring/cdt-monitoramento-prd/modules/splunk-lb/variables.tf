variable "instance_number" {
  type        = string
  description = "Instance number"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "e2-medium"
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

variable "disk_size" {
  type        = number
  description = "Disk size"
  default     = 20
}

variable "disk_type" {
  type        = string
  description = "Disk type"
  default     = "pd-balanced"
}

variable "labels" {
  type        = map(string)
  description = "Labels"
}

variable "certificate_file_path" {
  type        = string
  description = "Certificate file path"
}

variable "certificate_key_path" {
  type        = string
  description = "Certificate key path"
}

variable "loadbalance_ip" {
  type        = string
  description = "Load Balance IP"
}

variable "loadbalance_port" {
  type        = string
  description = "Load Balance Port"
}
