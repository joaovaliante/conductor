variable "subscription" {
  type        = string
  description = "Subscription ID"
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

variable "subnet_name_components" {
  type        = string
  description = "Subnet name of components"
}

variable "application_gateway_subnet_name" {
  type        = string
  description = "Subnet name"
}

variable "units" {
  type        = number
  description = "APIM Units"
}

variable "key_vault_name" {
  type        = string
  description = "Key vault name"
}

variable "key_vault_resource_group_name" {
  description = "Resource Group of KeyVault"
  type        = string
}

variable "user_identity" {
  type        = string
  description = "User Management Identity"
}

variable "certificate_name" {
  type        = string
  description = "Certificate Name"
}

variable "dns_value" {
  type        = string
  description = "DNS Value"
}

variable "cache_duration" {
  type        = string
  description = "Cache Duration in seconds"
}

variable "cache_duration_invalid" {
  type        = string
  description = "Cache Invalid Duration in seconds"
}

variable "backend_url" {
  type        = string
  description = "Backend URL"
}

variable "mimir_url" {
  type        = string
  description = "Mimir URL"
}

variable "log_level" {
  type        = string
  description = "APIM Log Level"
  default     = "INFO"
}

variable "mimir_authorization" {
  type        = string
  sensitive   = true
  description = "Mimir Authorization"
  default     = "#{MIMIR_AUTHORIZATION_TOKEN}#"
}

variable "tags" {
  type = map(string)
  default = {
    "Ambiente"     = "Producao"
    "Centro_Custo" = "Cloud"
    "Processing"   = "Issuer"
    "Produto"      = "API"
  }
}