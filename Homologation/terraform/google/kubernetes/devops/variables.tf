# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "network_project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

variable "zone" {
  type        = string
  description = "Zona a ser utilizada na Google Cloud."
  default     = "us-east1-b"
}

/******************************************
Variaveis GKE
*****************************************/
variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "kubernetes_enabled" {
  type        = bool
  default     = true
  description = "Enable / Disable Kubernetes"
}

variable "host_vpc_name" {
  type        = string
  default     = "gcpd-vpc"
  description = "Descreve o nome da host vpc utilizada."
}

variable "host_subnet_name" {
  type        = string
  description = "Descreve o nome da subnet da shared vpc utilizada."
}

variable "node_locations" {
  type        = list(any)
  description = "Descreve as zonas onde os nodes serao criados."
}

variable "master_authorized_networks" {
  default = [
    {
      cidr_block   = "10.19.248.0/23"
      display_name = "VPN Conductor"
    },
    {
      cidr_block   = "10.19.247.0/24"
      display_name = "VPN Conductor Checkpoint"
    },
    {
      cidr_block   = "10.51.15.0/24"
      display_name = "Azure Agents / Rancher"
    }
  ]
}