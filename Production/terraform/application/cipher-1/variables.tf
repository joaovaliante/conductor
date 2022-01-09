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
  description = "Rancher API Url"
  default     = null
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