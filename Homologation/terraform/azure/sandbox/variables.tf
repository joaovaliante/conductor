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

variable "tags" {
  type = map(string)
  default = {
    "Centro_Custo" = "Geeks"
    "Processing"   = "Issuer"
    "Ambiente"     = "DEV - Teste"
    "Produto"      = "Cloud Network"
    "Application"  = "FrontDoor"
  }
}

variable "key_vault_name" {
  type        = string
  description = "Key vault name"
}

variable "sandbox_dock_gke_address" {
  type        = string
  description = "Sandbox Dock IP Address"
}