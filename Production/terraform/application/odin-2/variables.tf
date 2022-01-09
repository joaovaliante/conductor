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
variable "odin_project" {
  type        = string
  description = "Odin Project Name"
  default     = "odin"
}

variable "odin_namespaces" {
  type        = list(string)
  description = "Odin Namespaces Name"
  default     = ["odin"]
}

/******************************************
Variaveis Helm - Rancher
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