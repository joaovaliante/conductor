# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}

variable "zone" {
  type        = string
  description = "Zona a ser utilizada na Google Cloud."
  default     = "us-east1-b"
}

variable "env_name" {
  type        = string
  default     = "prd"
  description = "Prefixo utilizado para nomear recursos."
}

variable "network_project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}

/******************************************
Variaveis GKE
*****************************************/
variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "kubernetes_enabled" {
  type        = bool
  default     = true
  description = "Enable / Disable Kubernetes"
}

variable "host_vpc_name" {
  type        = string
  default     = "gcpd-vpc"
  description = "Descreve o nome da host vpc utilizada."
}

variable "host_subnet_name" {
  type        = string
  description = "Descreve o nome da subnet da shared vpc utilizada."
}

variable "node_locations" {
  type        = list(any)
  description = "Descreve as zonas onde os nodes serao criados."
}

variable "master_authorized_networks" {
  default = [
    {
      cidr_block   = "10.19.248.0/23"
      display_name = "VPN Conductor"
    },
    {
      cidr_block   = "10.19.247.0/24"
      display_name = "VPN Conductor Checkpoint"
    },
    {
      cidr_block   = "10.51.15.0/24"
      display_name = "Azure Agents / Rancher"
    }
  ]
}

variable "rancher_url" {
  type        = string
  description = "Rancher API Url"
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token API"
  default     = "#{RANCHER_BEARER_TOKEN}#"
}

variable "monitoring_chart_version" {
  type        = string
  description = "Monitoring Chart version"
  default     = "#{MONITORING_CHART_VERSION}#"
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