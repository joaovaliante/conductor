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
variable "ingress_nginx_default_tls_cert" {
  type        = string
  description = "NGINX Ingress default certificate"
  default     = ""
}

variable "ingress_nginx_default_tls_key" {
  type        = string
  description = "NGINX Ingress default certificate key"
  default     = ""
}

variable "pier_enabled" {
  type        = bool
  description = "Enabled / Disabled Pier"
  default     = true
}

variable "heimdall_enabled" {
  type        = bool
  description = "Enabled / Disabled Heimdall"
  default     = true
}

variable "heimdall_version" {
  type        = string
  description = "Heimdall Version"
  default     = null
}

variable "heimdall_new_version" {
  type        = string
  description = "Heimdall New Version"
  default     = null
}

variable "heimdall_replicas" {
  type        = number
  description = "Heimdall Replicas"
}

variable "heimdall_new_version_replicas" {
  type        = number
  description = "Heimdall New Replicas"
  default     = 5
}

variable "pier_version" {
  type        = string
  description = "Pier Version"
  default     = null
}

variable "pier_new_version" {
  type        = string
  description = "Pier New Version"
  default     = null
}

variable "pier_replicas" {
  type        = number
  description = "Pier Replicas"
}

variable "pier_new_version_replicas" {
  type        = number
  description = "Pier New Replicas"
  default     = 5
}

variable "pier_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{PIER_CHART_VERSION}#"
}

variable "heimdall_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{HEIMDALL_CHART_VERSION}#"
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

variable "monitoring_datadog_environment" {
  type        = string
  description = "Monitoring Datadog environment"
  default     = "#{MONITORING_DATADOG_ENVIRONMENT}#"
}

variable "registry_password" {
  type        = string
  sensitive   = false
  description = "Registry password"
  default     = "#{REGISTRY_PASSWORD}#"
}

variable "pier_environment" {
  type        = string
  description = "Pier environment"
  default     = "#{PIER_ENVIRONMENT}#"
}

variable "pier_nfs_password" {
  type        = string
  sensitive   = false
  description = "Pier NFS password"
  default     = "#{PIER_NFS_SENHA}#"
}

variable "pier_cep_username" {
  type        = string
  description = "Pier CEP username"
  default     = "#{PIER_DATASOURCE_CEP_USERNAME}#"
}

variable "pier_cep_password" {
  type        = string
  sensitive   = false
  description = "Pier CEP password"
  default     = "#{PIER_DATASOURCE_CEP_PASSWORD}#"
}

variable "pier_harpia_username" {
  type        = string
  description = "Pier Harpia username"
  default     = "#{PIER_DATASOURCE_HARPIA_USERNAME}#"
}

variable "pier_harpia_password" {
  type        = string
  sensitive   = false
  description = "Pier Harpia password"
  default     = "#{PIER_DATASOURCE_HARPIA_PASSWORD}#"
}

variable "pier_db_username" {
  type        = string
  description = "Pier DB username"
  default     = "#{PIER_DATASOURCE_PIER_USERNAME}#"
}

variable "pier_db_password" {
  type        = string
  sensitive   = false
  description = "Pier DB password"
  default     = "#{PIER_DATASOURCE_PIER_PASSWORD}#"
}

variable "pier_quartz_password" {
  type        = string
  sensitive   = false
  description = "Pier Quartz password"
  default     = "#{PIER_DATASOURCE_QUARTZ_DATASOURCEPASSWORD}#"
}

variable "pier_dns" {
  type        = list(string)
  description = "Pier DNS"
  default     = []
}

/******************************************
Helm Variables - Mimir
*****************************************/
variable "mimir_keyVault_url" {
  type        = string
  description = "Mimir KeyVault URL"
  default     = "#{MIMIR_KEYVAULT_URL}#"
}

variable "mimir_apim_url" {
  type        = string
  description = "Mimir APIM URL"
  default     = "#{MIMIR_APIM_URL}#"
}

variable "mimir_client_id" {
  type        = string
  description = "Mimir ClientID"
  default     = "#{MIMIR_AZURE_CLIENT_ID}#"
}

variable "mimir_tenant_id" {
  type        = string
  description = "Mimir TenantID"
  default     = "#{MIMIR_AZURE_TENANT_ID}#"
}

variable "mimir_client_secret" {
  type        = string
  description = "Mimir Client Secret"
  default     = "#{MIMIR_AZURE_CLIENT_SECRET}#"
}

variable "mimir_subscription_id" {
  type        = string
  description = "Mimir SubscriptionID"
  default     = "#{MIMIR_AZURE_SUBSCRIPTION_ID}#"
}

variable "mimir_apim_subscription" {
  type        = string
  description = "Mimir APIM Subscription Key"
  default     = "#{MIMIR_SUBSCRIPTION_KEY}#"
}

variable "mimir_auth_sensedia" {
  type        = string
  description = "Mimir Sensedia Token"
  default     = "#{MIMIR_SENSEDIA_TOKEN}#"
}

variable "mimir_authentication_key" {
  type        = string
  description = "Mimir Authentication Key"
  default     = "#{MIMIR_AUTHENTICATION_KEY}#"
}

/******************************************
Helm Variables - Mercurio
*****************************************/
variable "mercurio_push_version" {
  type        = string
  description = "Mercurio Version"
}

variable "mercurio_sms_version" {
  type        = string
  description = "Mercurio Version"
}

variable "mercurio_chart_version" {
  type        = string
  description = "Mercurio Chart Version"
  default     = null
}

variable "mercurio_app_issuer" {
  type        = map(string)
  description = "Mercurio PUSH App Issuer"
  default = {
    "agillitas"     = "#{SMS_APP_ISSUER_AGILLITAS}#"
    "c6bank"        = "#{SMS_APP_ISSUER_C6BANK}#"
    "cbss"          = "#{PUSH_APP_ISSUER_CBSS}#"
    "fortbrasil"    = "#{SMS_APP_ISSUER_FORTBRASIL}#"
    "pernambucanas" = "#{PUSH_APP_ISSUER_PNB}#"
    "unicred"       = "#{SMS_APP_ISSUER_UNICRED}#"
    "xpi"           = "#{SMS_APP_ISSUER_XPI}#"
  }
}

variable "mercurio_app_version" {
  type        = map(string)
  description = "Mercurio App Version"
  default = {
    "agillitas"     = "#{SMS_APP_VERSION_AGILLITAS}#"
    "c6bank"        = "#{SMS_APP_VERSION_C6BANK}#"
    "cbss"          = "#{PUSH_APP_VERSION_CBSS}#"
    "fortbrasil"    = "#{SMS_APP_VERSION_FORTBRASIL}#"
    "pernambucanas" = "#{PUSH_APP_VERSION_PNB}#"
    "unicred"       = "#{SMS_APP_VERSION_UNICRED}#"
    "xpi"           = "#{SMS_APP_VERSION_XPI}#"
  }
}

variable "mercurio_database_connection_uri" {
  type        = map(string)
  description = "Mercurio PUSH Database Connection Uri"
  default = {
    "agillitas"     = "#{SMS_DATABASE_CONNECTION_URI_AGILLITAS}#"
    "c6bank"        = "#{SMS_DATABASE_CONNECTION_URI_C6BANK}#"
    "cbss"          = "#{PUSH_DATABASE_CONNECTION_URI_CBSS}#"
    "fortbrasil"    = "#{SMS_DATABASE_CONNECTION_URI_FORTBRASIL}#"
    "pernambucanas" = "#{PUSH_DATABASE_CONNECTION_URI_PNB}#"
    "unicred"       = "#{SMS_DATABASE_CONNECTION_URI_UNICRED}#"
    "xpi"           = "#{SMS_DATABASE_CONNECTION_URI_XPI}#"
  }
}

variable "mercurio_database_password" {
  type        = map(string)
  description = "Mercurio PUSH Database Password"
  default = {
    "agillitas"     = "#{SMS_DATABASE_PASSWORD_AGILLITAS}#"
    "c6bank"        = "#{SMS_DATABASE_PASSWORD_C6BANK}#"
    "cbss"          = "#{PUSH_DATABASE_PASSWORD_CBSS}#"
    "fortbrasil"    = "#{SMS_DATABASE_PASSWORD_FORTBRASIL}#"
    "pernambucanas" = "#{PUSH_DATABASE_PASSWORD_PNB}#"
    "unicred"       = "#{SMS_DATABASE_PASSWORD_UNICRED}#"
    "xpi"           = "#{SMS_DATABASE_PASSWORD_XPI}#"
  }
}

variable "mercurio_pier_token" {
  type        = map(string)
  description = "Mercurio PUSH Pier Token"
  default = {
    "agillitas"     = "#{SMS_PIER_TOKEN_AGILLITAS}#"
    "c6bank"        = "#{SMS_PIER_TOKEN_C6BANK}#"
    "cbss"          = "#{PUSH_PIER_TOKEN_CBSS}#"
    "fortbrasil"    = "#{SMS_PIER_TOKEN_FORTBRASIL}#"
    "pernambucanas" = "#{PUSH_PIER_TOKEN_PNB}#"
    "unicred"       = "#{SMS_PIER_TOKEN_UNICRED}#"
    "xpi"           = "#{SMS_PIER_TOKEN_XPI}#"
  }
}

variable "mercurio_splunk_token" {
  type        = map(string)
  description = "Mercurio PUSH Splunk Token"
  default = {
    "agillitas"     = "#{SMS_SPLUNK_TOKEN_AGILLITAS}#"
    "c6bank"        = "#{SMS_SPLUNK_TOKEN_C6BANK}#"
    "cbss"          = "#{PUSH_SPLUNK_TOKEN_CBSS}#"
    "fortbrasil"    = "#{SMS_SPLUNK_TOKEN_FORTBRASIL}#"
    "pernambucanas" = "#{PUSH_SPLUNK_TOKEN_PNB}#"
    "unicred"       = "#{SMS_SPLUNK_TOKEN_UNICRED}#"
    "xpi"           = "#{SMS_SPLUNK_TOKEN_XPI}#"
  }
}
variable "mercurio_cipher_token" {
  type        = map(string)
  description = "Mercurio SMS Cipher Token"
  default = {
    "agillitas"  = "#{SMS_CIPHER_TOKEN_AGILLITAS}#"
    "c6bank"     = "#{SMS_CIPHER_TOKEN_C6BANK}#"
    "fortbrasil" = "#{SMS_CIPHER_TOKEN_FORTBRASIL}#"
    "unicred"    = "#{SMS_CIPHER_TOKEN_UNICRED}#"
    "xpi"        = "#{SMS_CIPHER_TOKEN_XPI}#"
  }
}

variable "mercurio_registry_password" {
  type        = string
  sensitive   = false
  description = "Registry password"
  default     = "#{MERCURIO_REGISTRY_PASSWORD}#"
}

variable "mercurio_agillitas_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_AGILLITAS_REDIS_URL}#"
}

variable "mercurio_c6bank_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_C6BANK_REDIS_URL}#"
}

variable "mercurio_fortbrasil_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_FORTBRASIL_REDIS_URL}#"
}

variable "mercurio_pernambucanas_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_PERNAMBUCANAS_REDIS_URL}#"
}

variable "mercurio_unicred_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_UNICRED_REDIS_URL}#"
}

variable "mercurio_xpi_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_XPI_REDIS_URL}#"
}

variable "mercurio_cbss_redis_url" {
  type        = string
  description = "Mercurio Redis Url"
  default     = "#{MERCURIO_CBSS_REDIS_URL}#"
}

/******************************************
Mercurio Projects Variables - Rancher
*****************************************/
variable "mercurio_project" {
  type        = string
  description = "Mercurio Project Name"
  default     = "mercurio"
}

variable "mercurio_namespaces" {
  type        = list(string)
  description = "Mercurio Namespaces Name"
  default     = ["mercurio-agillitas", "mercurio-c6bank", "mercurio-fortbrasil", "mercurio-pernambucanas", "mercurio-unicred", "mercurio-xpi", "mercurio-cbss"]
}

/*******************************************
Variaveis Helm - VISA-DIRECT
*****************************************/

variable "visadirect_username" {
  type        = string
  description = "Visa-Direct Username"
  default     = "#{VISADIRECT_USERNAME}#"
}

variable "visadirect_password" {
  type        = string
  description = "Visa-Direct Password"
  default     = "#{VISADIRECT_PASSWORD}#"
}

variable "visadirect_mleidkey_password" {
  type        = string
  description = "Visa-Direct Mleidkey"
  default     = "#{VISADIRECT_MLEIDKEY}#"
}