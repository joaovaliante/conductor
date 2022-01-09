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
	Rancher
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

variable "alert_slack_channel" {
  type        = string
  description = "Slack channel used on AlertManager"
  default     = "#kubernetes-alerts-qa"
}

variable "alert_slack_url" {
  type        = string
  description = "Slack URL used on AlertManager"
  default     = "https://hooks.slack.com/services/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"
}

variable "monitoring_chart_version" {
  type        = string
  description = "Monitoring Chart version"
  default     = "#{MONITORING_CHART_VERSION}#"
}

variable "monitoring_prometheus_enabled" {
  type        = bool
  description = "Enable prometheus monitoring"
  default     = true
}