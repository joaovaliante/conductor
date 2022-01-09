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

/******************************************
Rancher
*****************************************/
variable "rancher_namespace" {
  type        = string
  description = "Rancher namespace"
  default     = "cattle-system"
}

variable "rancher_hostname" {
  type        = string
  description = "Rancher hostname"
}

variable "rancher_version" {
  type        = string
  description = "Rancher version"
}

variable "rancher_tls_cert" {
  type        = string
  description = "Certificate Value"
}

variable "rancher_tls_key" {
  type        = string
  description = "Certificate Value"
}

/******************************************
Helm Variables - Mimir
*****************************************/
variable "mimir_keyVault_url" {
  type        = string
  description = "Mimir KeyVault URL"
  default     = "#{MIMIR_KEYVAULT_URL}#"
}

variable "mimir_apim_url" {
  type        = string
  description = "Mimir APIM URL"
  default     = "#{MIMIR_APIM_URL}#"
}

variable "mimir_client_id" {
  type        = string
  description = "Mimir ClientID"
  default     = "#{MIMIR_AZURE_CLIENT_ID}#"
}

variable "mimir_tenant_id" {
  type        = string
  description = "Mimir TenantID"
  default     = "#{MIMIR_AZURE_TENANT_ID}#"
}

variable "mimir_client_secret" {
  type        = string
  description = "Mimir Client Secret"
  default     = "#{MIMIR_AZURE_CLIENT_SECRET}#"
}

variable "mimir_subscription_id" {
  type        = string
  description = "Mimir SubscriptionID"
  default     = "#{MIMIR_AZURE_SUBSCRIPTION_ID}#"
}

variable "mimir_apim_subscription_primary" {
  type        = string
  description = "Mimir APIM Subscription Key"
  default     = "#{MIMIR_SUBSCRIPTION_PRIMARY_KEY}#"
}

variable "mimir_apim_subscription_secondary" {
  type        = string
  description = "Mimir APIM Subscription Secondary Key"
  default     = "#{MIMIR_SUBSCRIPTION_SECONDARY_KEY}#"
}

variable "mimir_auth_sensedia" {
  type        = string
  description = "Mimir Sensedia Token"
  default     = "#{MIMIR_SENSEDIA_TOKEN}#"
}

variable "mimir_authentication_key" {
  type        = string
  description = "Mimir Authentication Key"
  default     = "#{MIMIR_AUTHENTICATION_KEY}#"
}

variable "mimir_key_salt" {
  type        = string
  description = "Mimir Key Salt"
  default     = "#{MIMIR_CACHES_REDIS_CONFIG_KEY}#"
}

/******************************************
Harness
*****************************************/
variable "harness_account_id" {
  type        = string
  sensitive   = true
  description = "Harness Account ID"
  default     = "#{HARNESS_ACCOUNT_ID}#"
}

variable "harness_account_secret" {
  type        = string
  sensitive   = true
  description = "Harness Account Secret"
  default     = "#{HARNESS_ACCOUNT_SECRET}#"
}

variable "harness_delegate_profile" {
  type        = string
  sensitive   = true
  description = "Harness Delegate Profile"
  default     = "#{HARNESS_DELEGATE_PROFILE}#"
}