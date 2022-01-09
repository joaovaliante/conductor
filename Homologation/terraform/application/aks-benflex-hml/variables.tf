variable "subscription" {
  type        = string
  description = "Subscription ID"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "registry_password" {
  type        = string
  description = "Monitoring Chart version"
  default     = "#{REGISTRY_PASSWORD}#"
}

/******************************************
Variaveis Helm - Applications
*****************************************/
variable "rancher_url" {
  type        = string
  description = "Rancher Url"
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token API"
  default     = "#{RANCHER_BEARER_TOKEN}#"
}

/******************************************
Variaveis Helm - Applications Benflex
*****************************************/

variable "pier_version" {
  type        = string
  description = "Pier version"
}

variable "pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "pier_chart_version" {
  type        = string
  description = "Pier Chart version"
  default     = "#{PIER_BENFLEX_HMLG_CHART_VERSION}#"
}

variable "neo_version" {
  type        = string
  description = "Neo version"
}

variable "neo_chart_version" {
  type        = string
  description = "Neo Chart version"
  default     = "#{NEO_BENFLEX_HMLG_CHART_VERSION}#"
}

/******************************************
Variaveis Helm - Ingress
*****************************************/
variable "ingress_nginx_default_tls_cert" {
  type        = string
  description = "NGINX Ingress default certificate"
  default     = ""
}

variable "ingress_nginx_default_tls_key" {
  type        = string
  description = "NGINX Ingress default certificate key"
  default     = ""
}

