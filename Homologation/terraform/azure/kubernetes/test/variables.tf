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
    "Centro_Custo" = "Cloud"
    "Processing"   = "Issuer"
    "Ambiente"     = "DEV - Teste"
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "host_admin_username" {
  type        = string
  description = "Username of node host"
  # default     = "#{HOST_SSH_USERNAME}#"
  default = "adm_conductor"
}

variable "host_admin_key_content" {
  type        = string
  description = "SSH Key content of admin user"
  # default     = "#{HOST_SSH_KEY}#"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKEXiNO1s+fTJ8VsNdsZ482bG7nrCAZ1BfnIhPjzajvtIe8I6Z8+FmOZUFO5BlEf4Y9SbQg0veT4hC4tn/DTx6kfwa25RZfEabMFYg+P0pLup4n85+O5rMeWhPCL0xYwMgaE2YyMOSVFgEMwNdRS+wXduSRhDhUFeRP2IdiSWt5tDes8PJumh4BRMh9ZiuYxAmkSok/xZwlTc3OeUgn5++SHy5wfEbmtvkil3Qrq9xlje9E+59SP1+HFZ0P8Xx6ODSFuW8yBPUpDQ2uY66dD6+CwxKhfC/Dvc0tdftmN4IkweLT5y8OMjXf3tQzfjob65ZaliqVfxK3ytyySsiodmKOymM+mzP9EAA7F09pSiM5rvpHgtYHr/vCgnZzBRbbw+rhldL0NS/b/kz5ZJd4OwiNps9nhtutB3i99WuX1/E+ULdh7Z+81D6+jyv/Z6A4lS12FhNI/XZck6/OKUUwQitjVvqbRx2TmmC1DpsRIzT2IHk4C4mxCfctgLYuekUNik= ykg@DESKTOP-PJ0V4PI"
}

variable "service_principal_id" {
  type        = string
  description = "Service Principal AppId"
  # default     = "#{SERVICE_PRINCIPAL_ID}#"
  default = "70a16ecb-c2fb-4db7-b52a-324ff92eb9e2"
}

variable "service_principal_secret" {
  type        = string
  description = "Service Principal Password"
  # default     = "#{SERVICE_PRINCIPAL_SECRET}#"
  default = "7h~Xky_sh5GXjXd_UBOATUbQJEcb5W68BR"
}

variable "machine_type" {
  type        = string
  description = "Machine type"
  # default     = "Standard_F8s_v2"
  default = "Standard_D8s_v3"
}

variable "machine_min" {
  type        = number
  description = "Min machines"
  default     = 3
}

variable "machine_max" {
  type        = number
  description = "Max machines"
  default     = 30
}

variable "alert_slack_channel" {
  type        = string
  description = "Slack channel used on AlertManager"
  default     = "#kubernetes-alerts-qa"
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
  # default     = "#{RANCHER_BEARER_TOKEN}#"
  default = "token-dllzs:2qf4whx4xzbg8wnzh87dv8jvc5qlff5gfw5jg6wrrrdpzcvpnfrhpp"
}

variable "monitoring_chart_version" {
  type        = string
  description = "Monitoring Chart version"
  # default     = "#{MONITORING_CHART_VERSION}#"
  default = "13.2.1"
}