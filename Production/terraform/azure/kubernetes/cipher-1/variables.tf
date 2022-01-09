variable "subscription" {
  type        = string
  description = "Subscription ID"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "location" {
  type        = string
  description = "Location name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual Network name"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource Group of virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name"
}

variable "tags" {
  type = map(string)
  default = {
    "Centro_Custo" = "PCI"
    "Processing"   = "Issuer"
    "Produto"      = "API"
    "Application"  = "Cipher"
    "Ambiente"     = "Producao"
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "host_admin_username" {
  type        = string
  description = "Username of node host"
  default     = "#{HOST_SSH_USERNAME}#"
}

variable "host_admin_key_content" {
  type        = string
  description = "SSH Key content of admin user"
  default     = "#{HOST_SSH_KEY}#"
}

variable "service_principal_id" {
  type        = string
  description = "Service Principal AppId"
  default     = "#{SERVICE_PRINCIPAL_ID}#"
}

variable "service_principal_secret" {
  type        = string
  description = "Service Principal Password"
  default     = "#{SERVICE_PRINCIPAL_SECRET}#"
}

/******************************************
Variaveis Helm - Applications
*****************************************/
variable "ingress_nginx_enabled" {
  type        = bool
  default     = true
  description = "Enable / Disable NGINX Ingress"
}

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

variable "odin_primary_enabled" {
  type        = bool
  description = "Enabled / Disabled Odin Primary"
  default     = true
}

variable "odin_secondary_enabled" {
  type        = bool
  description = "Enabled / Disabled Odin Secondary"
  default     = true
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

variable "odin_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.2.6"
}

variable "pier_custom_values" {
  type        = list(any)
  description = "List of custom values of Pier"
  default     = []
}

variable "heimdall_custom_values" {
  type        = list(any)
  description = "List of custom values of Pier"
  default     = []
}

variable "odin_primary_custom_values" {
  type        = list(any)
  description = "List of custom values of Primary Odin"
  default     = []
}

variable "odin_secondary_custom_values" {
  type        = list(any)
  description = "List of custom values of Secondary Odin"
  default     = []
}

variable "rancher_url" {
  type        = string
  description = "Rancher API Url"
  default     = null
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token API"
  default     = "#{RANCHER_BEARER_TOKEN}#"
}

variable "monitoring_chart_version" {
  type        = string
  description = "Monitoring Chart version"
  default     = "#{MONITORING_CHART_VERSION}#"
}

variable "monitoring_datadog_api_key" {
  type        = string
  description = "Monitoring Datadog API Key"
  default     = "#{MONITORING_DATADOG_APIKEY}#"
  sensitive   = true
}

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}

variable "monitoring_datadog_environment_type" {
  type        = string
  description = "Monitoring Datadog environment type"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT_TYPE}#"
}