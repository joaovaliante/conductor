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

variable "jarvis_enabled" {
  type        = bool
  description = "Enabled / Disabled Jarvis"
  default     = true
}

variable "kafka_enabled" {
  type        = bool
  description = "Enabled / Disabled Kafka"
  default     = true
}

variable "jarvis_version" {
  type        = string
  description = "Jarvis Version"
  default     = null
}

variable "jarvis_new_version" {
  type        = string
  description = "Jarvis New Version"
  default     = null
}

variable "kafka_version" {
  type        = string
  description = "Kafka Version"
  default     = null
}

variable "kafka_new_version" {
  type        = string
  description = "Kafka New Version"
  default     = null
}

variable "jarvis_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{JARVIS_CHART_VERSION}#"
}

variable "kafka_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{KAFKA_CHART_VERSION}#"
}

/******************************************
Jarvis Projects Variables - Rancher
*****************************************/
variable "jarvis_project" {
  type        = string
  description = "Jarvis Project Name"
  default     = "jarvis"
}

variable "jarvis_namespaces" {
  type        = list(string)
  description = "Jarvis Namespaces Name"
  default     = ["jarvis"]
}

/******************************************
Kafka Projects Variables - Rancher
*****************************************/

variable "kafka_project" {
  type        = string
  description = "Kafka Project Name"
  default     = "kafka"
}

variable "kafka_namespaces" {
  type        = list(string)
  description = "Kafka Namespaces Name"
  default     = ["kafka"]
}

/******************************************
Rancher Variables 
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

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}