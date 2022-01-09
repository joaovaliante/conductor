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

/******************************************
Variaveis Helm - Applications
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

variable "pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = null
}

variable "heimdall_new_version" {
  type        = string
  description = "Heimdall New Version"
  default     = null
}

variable "heimdall_replicas" {
  type        = number
  description = "Heimdall Replicas"
}

variable "heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Replicas"
  default     = 5
}

variable "pier_version" {
  type        = string
  description = "Pier Version"
  default     = null
}

variable "pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "pier_replicas" {
  type        = number
  description = "Pier Replicas"
}

variable "pier_new_version_replicas" {
  type        = number
  description = "Pier New Replicas"
  default     = 5
}

variable "pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{PIER_CHART_VERSION}#"
}

variable "heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{HEIMDALL_CHART_VERSION}#"
}

variable "rancher_url" {
  type        = string
  description = "Rancher Url"
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token API"
  default     = "#{RANCHER_BEARER_TOKEN}#"
}

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}

variable "registry_password" {
  type        = string
  sensitive   = false
  description = "Registry password"
  default     = "#{REGISTRY_PASSWORD}#"
}

variable "pier_environment" {
  type        = string
  description = "Pier environment"
  default     = "#{PIER_ENVIRONMENT}#"
}

variable "pier_nfs_password" {
  type        = string
  sensitive   = false
  description = "Pier NFS password"
  default     = "#{PIER_NFS_SENHA}#"
}

variable "pier_cep_username" {
  type        = string
  description = "Pier CEP username"
  default     = "#{PIER_DATASOURCE_CEP_USERNAME}#"
}

variable "pier_cep_password" {
  type        = string
  sensitive   = false
  description = "Pier CEP password"
  default     = "#{PIER_DATASOURCE_CEP_PASSWORD}#"
}

variable "pier_harpia_username" {
  type        = string
  description = "Pier Harpia username"
  default     = "#{PIER_DATASOURCE_HARPIA_USERNAME}#"
}

variable "pier_harpia_password" {
  type        = string
  sensitive   = false
  description = "Pier Harpia password"
  default     = "#{PIER_DATASOURCE_HARPIA_PASSWORD}#"
}

variable "pier_db_username" {
  type        = string
  description = "Pier DB username"
  default     = "#{PIER_DATASOURCE_PIER_USERNAME}#"
}

variable "pier_db_password" {
  type        = string
  sensitive   = false
  description = "Pier DB password"
  default     = "#{PIER_DATASOURCE_PIER_PASSWORD}#"
}

variable "pier_quartz_password" {
  type        = string
  sensitive   = false
  description = "Pier Quartz password"
  default     = "#{PIER_DATASOURCE_QUARTZ_DATASOURCEPASSWORD}#"
}

variable "pier_dns" {
  type        = list(string)
  description = "Pier DNS"
  default     = []
}
