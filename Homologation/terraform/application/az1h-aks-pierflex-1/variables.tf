variable "cluster_name" {
  type        = string
  description = "Cluster Name"
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
variable "subscription" {
  type        = string
  description = "Subscription ID"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "slack_api_url" {
  type        = string
  description = "Slack API URL"
  default     = "#{SLACK_API_URL}#"
}
/******************************************
Istio Variables 
*****************************************/
variable "istio_namespace" {
  type        = string
  description = "Rancher namespace"
  default     = "istio-system"
}
variable "istio_gateway_namespace" {
  type        = string
  description = "Rancher namespace"
  default     = "inbound"
}

/******************************************
Harness Variables 
*****************************************/
variable "harness_secret_manager_id" {
  type        = string
  description = "Harness Azure Secret Manager ID"
}

variable "harness_account_id" {
  type        = string
  description = "Harness Account ID"
}

variable "harness_api_key" {
  type        = string
  description = "Harness API KEY"
  default     = "#{HARNESS_API_KEY}#"
}

variable "harness_application_id" {
  type        = string
  description = "Harness Application ID"
}

variable "environment_id" {
  type        = string
  description = "Environment ID in Harness application"
}

variable "pierflex_namespaces" {
  type        = list(map(string))
  description = "PierFlex Namespaces"
}