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
    "Ambiente"     = "DEV - Teste"
    "Centro_Custo" = "Cloud"
    "Processing"   = "Issuer"
    "Produto"      = "API"
  }
}