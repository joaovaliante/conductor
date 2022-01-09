variable "subscription" {
  type        = string
  description = "Subscription ID"
}

variable "dns_zone_name" {
  type        = string
  description = "DNS Zone Name"
}

variable "dns_zone_description" {
  type        = string
  description = "DNS Zone Description"
}

variable "dns_name" {
  type        = string
  description = "DNS Name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "project" {
  type        = string
  description = "Google Project Name"
}

variable "tags" {
  type = map(string)
}