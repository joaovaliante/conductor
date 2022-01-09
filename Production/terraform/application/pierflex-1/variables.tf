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

/******************************************
 Variaveis Helm - Applications
 *****************************************/

variable "tokenization_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "#{TOKENIZATION_CHART_VERSION}#"
}

/******************************************
 Tokenization-Mater
 *****************************************/

variable "tokenization_master_version" {
  type        = string
  description = "Tokenization-Master Version"
  default     = null
}

/******************************************
 Tokenization-Visa
 *****************************************/

variable "tokenization_visa_version" {
  type        = string
  description = "Tokenization-Visa Version"
  default     = null
}

/******************************************
 Tokenization-Public
 *****************************************/

variable "tokenization_public_version" {
  type        = string
  description = "Tokenization-Public Version"
  default     = null
}

/******************************************
 Tokenization Projects Variables - Rancher
 *****************************************/
variable "tokenization_project" {
  type        = string
  description = "Tokenization Project Name"
  default     = "Tokenization"
}

variable "tokenization_namespaces" {
  type        = list(string)
  description = "Tokenization Namespaces Name"
  default     = ["tokenization"]
}

/*******************************************
  Variables Helm - Account
 *****************************************/
variable "account_version" {
  type        = string
  description = "Account Version"
  default     = null
}

variable "account_chart_version" {
  type        = string
  description = "Account Chart Version"
  default     = "#{ACCOUNT_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Aggregator
 *****************************************/

variable "aggregator_version" {
  type        = string
  description = "Aggregator Version"
  default     = null
}

variable "aggregator_chart_version" {
  type        = string
  description = "Aggregator Chart Version"
  default     = "#{AGGREGATOR_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Bankslip
 *****************************************/

variable "bankslip_version" {
  type        = string
  description = "Bankslip Version"
  default     = null
}

variable "bankslip_chart_version" {
  type        = string
  description = "Bankslip Chart Version"
  default     = "#{BANKSLIP_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Billing
 *****************************************/
variable "billing_version" {
  type        = string
  description = "Billing Version"
  default     = null
}

variable "billing_chart_version" {
  type        = string
  description = "Billing Chart Version"
  default     = "#{BILLING_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Cipher
 *****************************************/
variable "cipher_version" {
  type        = string
  description = "Cipher Version"
  default     = null
}

variable "cipher_chart_version" {
  type        = string
  description = "Cipher Chart Version"
  default     = "#{CIPHER_CHART_VERSION}#"
}


/*******************************************
  Variables Helm - Control
 *****************************************/

variable "control_version" {
  type        = string
  description = "Control Version"
  default     = null
}

variable "control_chart_version" {
  type        = string
  description = "Control Chart Version"
  default     = "#{CONTROL_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Datahub
 *****************************************/

variable "datahub_version" {
  type        = string
  description = "Datahub Version"
  default     = null
}

variable "datahub_chart_version" {
  type        = string
  description = "Datahub Chart Version"
  default     = "#{DATAHUB_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Embossing
 *****************************************/

variable "embossing_version" {
  type        = string
  description = "Embossing Version"
  default     = null
}

variable "embossing_chart_version" {
  type        = string
  description = "Embossing Chart Version"
  default     = "#{EMBOSSING_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Events
 *****************************************/

variable "events_version" {
  type        = string
  description = "Events Version"
  default     = null
}

variable "events_chart_version" {
  type        = string
  description = "Events Chart Version"
  default     = "#{EVENTS_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Exchange
 *****************************************/
variable "exchange_version" {
  type        = string
  description = "Exchange Version"
  default     = null
}

variable "exchange_chart_version" {
  type        = string
  description = "Exchange Chart Version"
  default     = "#{EXCHANGE_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Falcon-Connector
 *****************************************/

variable "falcon_connector_version" {
  type        = string
  description = "Falcon-Connector Version"
  default     = null
}

variable "falcon_connector_chart_version" {
  type        = string
  description = "Falcon-Connector Chart Version"
  default     = "#{FALCON-CONNECTOR_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Falcon-Card-Connector
 *****************************************/

variable "falcon_card_connector_version" {
  type        = string
  description = "Falcon-Card-Connector Version"
  default     = null
}

variable "falcon_card_connector_chart_version" {
  type        = string
  description = "Falcon-Card-Connector Chart Version"
  default     = "#{FALCON-CARD-CONNECTOR_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Issuer
 *****************************************/
variable "issuer_version" {
  type        = string
  description = "Issuer Version"
  default     = null
}

variable "issuer_chart_version" {
  type        = string
  description = "Issuer Chart Version"
  default     = "#{ISSUER_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Operation
 *****************************************/
variable "operation_version" {
  type        = string
  description = "Operation Version"
  default     = null
}

variable "operation_chart_version" {
  type        = string
  description = "Operation Chart Version"
  default     = "#{OPERATION_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Orchestrator
 *****************************************/
variable "orchestrator_version" {
  type        = string
  description = "Orchestrator Version"
  default     = null
}

variable "orchestrator_chart_version" {
  type        = string
  description = "Orchestrator Chart Version"
  default     = "#{ORCHESTRATOR_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Person
 *****************************************/
variable "person_version" {
  type        = string
  description = "Person Version"
  default     = null
}

variable "person_chart_version" {
  type        = string
  description = "Person Chart Version"
  default     = "#{PERSON_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Piercards
 *****************************************/
variable "piercards_version" {
  type        = string
  description = "Piercards Version"
  default     = null
}

variable "piercards_chart_version" {
  type        = string
  description = "Piercards Chart Version"
  default     = "#{PIERCARDS_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Product
 *****************************************/
variable "product_version" {
  type        = string
  description = "Product Version"
  default     = null
}

variable "product_chart_version" {
  type        = string
  description = "Product Chart Version"
  default     = "#{PRODUCT_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Statement
 *****************************************/
variable "statement_version" {
  type        = string
  description = "Statement Version"
  default     = null
}

variable "statement_chart_version" {
  type        = string
  description = "Statement Chart Version"
  default     = "#{STATEMENT_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Transaction
 *****************************************/
variable "transaction_version" {
  type        = string
  description = "Transaction Version"
  default     = null
}

variable "transaction_chart_version" {
  type        = string
  description = "Transaction Chart Version"
  default     = "#{TRANSACTION_CHART_VERSION}#"
}

/*******************************************
  Variables Helm - Vhub
 *****************************************/
variable "vhub_version" {
  type        = string
  description = "Vhub Version"
  default     = null
}

variable "vhub_chart_version" {
  type        = string
  description = "Vhub Chart Version"
  default     = "#{VHUB_CHART_VERSION}#"
}

 