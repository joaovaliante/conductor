variable "subscription" {
  type        = string
  description = "Subscription ID"
}
variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}
variable "location" {
  type        = string
  description = "Location name"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "virtual_network_name" {
  type        = string
  description = "Virtual Network name"
}
variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource Group of virtual network"
}
variable "subnet_name" {
  type        = string
  description = "Subnet name"
}
variable "tags" {
  type = map(string)
  default = {
    "Centro_Custo" = "PierFlex"
    "Processing"   = "Issuer"
    "Ambiente"     = "HML"
    "Produto"      = "Microservices"
    "Squad"        = "PierFlex"
  }
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "host_admin_username" {
  type        = string
  description = "Username of node host"
  default     = "#{HOST_SSH_USERNAME}#"
}
variable "host_admin_key_content" {
  type        = string
  description = "SSH Key content of admin user"
  default     = "#{HOST_SSH_KEY}#"
}
variable "service_principal_id" {
  type        = string
  description = "Service Principal AppId"
  default     = "#{SERVICE_PRINCIPAL_ID}#"
}
variable "service_principal_secret" {
  type        = string
  description = "Service Principal Password"
  default     = "#{SERVICE_PRINCIPAL_SECRET}#"
}
variable "alert_slack_channel" {
  type        = string
  description = "Slack channel used on AlertManager"
  default     = "#kubernetes-alerts-qa"
}
variable "alert_slack_url" {
  type        = string
  description = "Slack URL used on AlertManager"
  default     = "#{SLACK_URL}#"
}
/******************************************
 	Vnext-Geral
  *****************************************/
variable "vnext_geral_hml_machine_type" {
  type        = string
  description = "Vnext-geral HML machine type"
  default     = "Standard_F8s_v2"
}
variable "vnext_geral_hml_min" {
  type        = number
  description = "Min Vnext-geral HML machines"
  default     = 3
}
variable "vnext_geral_hml_max" {
  type        = number
  description = "Max Vnext-geral HML machines"
  default     = 10
}
/******************************************
 Variaveis Helm - Applications
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
variable "monitoring_chart_version" {
  type        = string
  description = "Monitoring Chart version"
  default     = "#{MONITORING_CHART_VERSION}#"
}