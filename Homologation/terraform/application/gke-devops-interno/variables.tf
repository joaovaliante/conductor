# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

/******************************************
Variaveis GKE
*****************************************/
variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

/******************************************
Rundeck
*****************************************/
variable "cert_value" {
  type        = string
  description = "Certificate Value"
}

variable "cert_key_value" {
  type        = string
  description = "Certificate Value"
}

variable "registry_password" {
  type        = string
  description = "Registry Password"
  default     = "#{REGISTRY_PASSWORD}#"
}

variable "storage_access_key" {
  type        = string
  description = "Azure Storage access key"
  default     = "#{STORAGE_ACCESS_KEY}#"
}

variable "ldap_password" {
  type        = string
  description = "Ldap password"
  default     = "#{LDAP_PASSWORD}#"
}