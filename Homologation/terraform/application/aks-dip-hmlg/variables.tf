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

