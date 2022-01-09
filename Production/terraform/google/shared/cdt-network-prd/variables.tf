# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

variable "gke_region" {
  type        = string
  description = "Regiao principal a ser utilizada no GKE."
}

variable "db_region" {
  type        = string
  description = "Regiao principal a ser utilizada no DB."
}

variable "zone" {
  type        = string
  description = "Zona a ser utilizada na Google Cloud."
  default     = "us-east1-b"
}

variable "env_name" {
  type        = string
  default     = "prd"
  description = "Prefixo utilizado para nomear recursos."
}

variable "project_services_apis" {
  type        = list(any)
  description = "Lista de Apis necessarias para criação dos recursos neste projeto"
}

# variaveis network
variable "tuneis" {
  description = "Contem uma lista de opjettos contendo informacoes para criacao de tuneis de vpn."
  default = [
  ]
}

variable "ad_ip" {
  type        = string
  default     = "10.54.10.21"
  description = "IP Address of AD"
}
