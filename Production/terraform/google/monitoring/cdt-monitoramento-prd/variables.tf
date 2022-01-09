# variaveis comuns
variable "project" {
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

variable "env_name" {
  type        = string
  default     = "prd"
  description = "Prefixo utilizado para nomear recursos."
}

variable "host_network_project" {
  type        = string
  description = "Descreve o nome da projeto host da shared vpc utilizada."
}

variable "host_vpc_name" {
  type        = string
  default     = "gcp2p-prd-vpc"
  description = "Descreve o nome da host vpc utilizada."
}

variable "host_subnet_name" {
  type        = string
  description = "Descreve o nome da subnet da shared vpc utilizada."
}

variable "timezone" {
  type        = string
  description = "Timezone of Machines"
  default     = "UTC"
}

variable "labels" {
  type        = map(string)
  description = "Labels"
  default     = { "centro_custo" : "infra-producao", "produto" : "splunk", "processing" : "issuer", "aplicacao" : "spkunk-indexer" }
}