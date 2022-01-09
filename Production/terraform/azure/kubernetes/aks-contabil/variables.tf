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
variable "rancher_base_url" {
  type        = string
  description = "Rancher base URL"
  default     = "#{RANCHER_BASE_URL}#"
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

variable "alert_slack_channel" {
  type        = string
  description = "Slack channel used on AlertManager"
  default     = "#kubernetes-alerts"
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
  description = "Enable prometheus monitoring "
  default     = true
}


/******************************************
Variaveis Helm - Datadog
*****************************************/

variable "monitoring_datadog_enabled" {
  type        = bool
  description = "Enable Datadog Monitoring"
  default     = true
}

variable "monitoring_datadog_api_key" {
  type        = string
  description = "Monitoring Datadog API Key"
  default     = "#{MONITORING_DATADOG_APIKEY}#"
  sensitive   = true
}

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}

variable "monitoring_datadog_environment_type" {
  type        = string
  description = "Monitoring Datadog environment type"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT_TYPE}#"
}

