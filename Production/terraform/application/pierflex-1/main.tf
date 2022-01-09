/******************************************
 Locals
  *****************************************/
locals {
  rancher_api_url = "${var.rancher_url}/v3"
}

/******************************************
 Data Source
  *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/kubernetes/data/cluster"

  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
}

/******************************************
 Istio Namespace
  *****************************************/

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = var.istio_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

module "istio_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = "Istio-system"
  namespaces    = ["istio-system"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

}

/******************************************
 Istio
  *****************************************/

data "kubectl_file_documents" "istio-manifests" {
  content = file("${path.module}/../../../manifest/istio/istio.yaml")
}

resource "kubectl_manifest" "istio" {
  count              = length(data.kubectl_file_documents.istio-manifests.documents)
  yaml_body          = element(data.kubectl_file_documents.istio-manifests.documents, count.index)
  override_namespace = var.istio_namespace

  depends_on = [
    module.istio_namespace
  ]
}

/******************************************
 Istio Gateway Namespace
  *****************************************/

resource "kubernetes_namespace" "inbound" {
  metadata {
    name = var.istio_gateway_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

module "istio_gateway_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = "Inbound"
  namespaces    = ["inbound"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    resource.kubernetes_namespace.inbound
  ]

}

/******************************************
 Istio Gateway
  *****************************************/

data "kubectl_file_documents" "istio-gateway-manifests" {
  content = file("${path.module}/../../../manifest/istio-gateway/gateway.yaml")
}

resource "kubectl_manifest" "istio-gateway" {
  count              = length(data.kubectl_file_documents.istio-gateway-manifests.documents)
  yaml_body          = element(data.kubectl_file_documents.istio-gateway-manifests.documents, count.index)
  override_namespace = var.istio_gateway_namespace

  depends_on = [
    module.istio_gateway_namespace
  ]
}

#/******************************************
# Observability - Prometheus
#  *****************************************/
#
#data "kubectl_file_documents" "prometheus-manifests" {
#  content = file("${path.module}/../../../manifest/prometheus/prometheus.yaml")
#}
#
#resource "kubectl_manifest" "prometheus" {
#  count     = length(data.kubectl_file_documents.prometheus-manifests.documents)
#  yaml_body = element(data.kubectl_file_documents.prometheus-manifests.documents, count.index)
#
#  depends_on = [
#    module.istio_namespace
#  ]
#}
#
#/******************************************
# Observability - Grafana
#  *****************************************/
#
#data "kubectl_file_documents" "grafana-manifests" {
#  content = file("${path.module}/../../../manifest/grafana/grafana.yaml")
#}
#
#resource "kubectl_manifest" "grafana" {
#  count     = length(data.kubectl_file_documents.grafana-manifests.documents)
#  yaml_body = element(data.kubectl_file_documents.grafana-manifests.documents, count.index)
#
#  depends_on = [
#    module.istio_namespace
#  ]
#}
#
#/******************************************
# Observability - Jaeger
#  *****************************************/
#
#data "kubectl_file_documents" "jaeger-manifests" {
#  content = file("${path.module}/../../../manifest/jaeger/jaeger.yaml")
#}
#
#resource "kubectl_manifest" "jaeger" {
#  count     = length(data.kubectl_file_documents.jaeger-manifests.documents)
#  yaml_body = element(data.kubectl_file_documents.jaeger-manifests.documents, count.index)
#
#  depends_on = [
#    module.istio_namespace
#  ]
#}
#
#/******************************************
# Observability - Kiali
#  *****************************************/
#
#data "kubectl_file_documents" "kiali-manifests" {
#  content = file("${path.module}/../../../manifest/kiali/kiali.yaml")
#}
#
#resource "kubectl_manifest" "kiali" {
#  count     = length(data.kubectl_file_documents.kiali-manifests.documents)
#  yaml_body = element(data.kubectl_file_documents.kiali-manifests.documents, count.index)
#
#  depends_on = [
#    module.istio_namespace
#  ]
#}
#
/******************************************
 Helm Tokenization-Master
  *****************************************/
module "helm_tokenization_master" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/tokenization"

  application_version = var.tokenization_master_version
  chart_version       = var.tokenization_chart_version
  name                = "tokenization-master"
  values_contents = [
    file("../../../helm/application/tokenization/values-tokenization.yaml"),
    file("../../../helm/application/tokenization/values-tokenization-mastercard.yaml"),
    file("../../../helm/azure/tokenization/values-tokenization.yaml")
  ]

}

/******************************************
 Helm Tokenization-Visa
  *****************************************/
module "helm_tokenization_visa" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/tokenization"

  application_version = var.tokenization_visa_version
  chart_version       = var.tokenization_chart_version
  name                = "tokenization-visa"
  values_contents = [
    file("../../../helm/application/tokenization/values-tokenization.yaml"),
    file("../../../helm/application/tokenization/values-tokenization-visa.yaml"),
    file("../../../helm/azure/tokenization/values-tokenization.yaml")
  ]
  depends_on = [
    module.helm_tokenization_master
  ]
}

/******************************************
 Helm Tokenization-Public
  *****************************************/
module "helm_tokenization_public" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/tokenization"

  application_version = var.tokenization_public_version
  chart_version       = var.tokenization_chart_version
  name                = "tokenization-public"
  values_contents = [
    file("../../../helm/application/tokenization/values-tokenization.yaml"),
    file("../../../helm/application/tokenization/values-tokenization-public.yaml"),
    file("../../../helm/azure/tokenization/values-tokenization.yaml")
  ]
  depends_on = [
    module.helm_tokenization_visa
  ]
}

/******************************************
 Tokenization
  *****************************************/
module "rancher_tokenization_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  cluster_name  = var.cluster_name
  project       = var.tokenization_project
  namespaces    = var.tokenization_namespaces
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_tokenization_public
  ]
}


/******************************************
  Helm Account
  *****************************************/
module "helm_account_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/account"
  name                 = "account"
  chart_version        = var.account_chart_version
  namespace            = "account"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/account/values-account-vnext.yaml", {
      version = var.account_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_account_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Account"
  namespaces    = ["account"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_account_application
  ]
}

/******************************************
  Helm Aggregator
  *****************************************/

module "helm_aggregator_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/aggregator"
  name                 = "aggregator"
  chart_version        = var.aggregator_chart_version
  namespace            = "aggregator"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/aggregator/values-aggregator-vnext.yaml", {
      version = var.aggregator_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_aggregator_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Aggregator"
  namespaces    = ["aggregator"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_aggregator_application
  ]
}

/******************************************
  Helm Billing
  *****************************************/
module "helm_billing_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/billing"
  name                 = "billing"
  chart_version        = var.billing_chart_version
  namespace            = "billing"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/billing/values-billing-vnext.yaml", {
      version = var.billing_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_billing_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Billing"
  namespaces    = ["billing"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_billing_application
  ]
}

/******************************************
  Helm Cipher
  *****************************************/
module "helm_cipher_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/cipher"
  name          = "cipher"
  chart_version = var.cipher_chart_version
  namespace     = "cipher"
  values_contents = [
    templatefile("../../../helm/application/cipher/values-cipher-vnext.yaml", {
      version = var.cipher_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_cipher_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Cipher"
  namespaces    = ["cipher"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_cipher_application
  ]
}

/******************************************
  Helm Control
  *****************************************/

module "helm_control_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/control"
  name                 = "control"
  chart_version        = var.control_chart_version
  namespace            = "control"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/control/values-control-vnext.yaml", {
      version = var.control_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_control_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Control"
  namespaces    = ["control"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_control_application
  ]
}

/******************************************
  Helm Embossing
  *****************************************/
module "helm_embossing_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/embossing"
  name                 = "embossing"
  chart_version        = var.embossing_chart_version
  namespace            = "embossing"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/embossing/values-embossing-vnext.yaml", {
      version = var.embossing_version
    })
  ]
}

module "rancher_embossing_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Embossing"
  namespaces    = ["embossing"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_embossing_application
  ]
}

/******************************************
  Helm Events
  *****************************************/

module "helm_events_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/events"
  name                 = "events"
  chart_version        = var.events_chart_version
  namespace            = "events"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/events/values-events-vnext.yaml", {
      version = var.events_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_events_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Events"
  namespaces    = ["events"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_events_application
  ]
}

/******************************************
  Helm Exchange
  *****************************************/
module "helm_exchange_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/exchange"
  name                 = "exchange"
  chart_version        = var.exchange_chart_version
  namespace            = "exchange"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/exchange/values-exchange-vnext.yaml", {
      version = var.exchange_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_exchange_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Exchange"
  namespaces    = ["exchange"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_exchange_application
  ]
}


/******************************************
  Helm Issuer
  *****************************************/

module "helm_issuer_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/issuer"
  name                 = "issuer"
  chart_version        = var.issuer_chart_version
  namespace            = "issuer"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/issuer/values-issuer-vnext.yaml", {
      version = var.issuer_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_issuer_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Issuer"
  namespaces    = ["issuer"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_issuer_application
  ]
}

/******************************************
  Helm Operation
  *****************************************/

module "helm_operation_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/operation"
  name                 = "operation"
  chart_version        = var.operation_chart_version
  namespace            = "operation"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/operation/values-operation-vnext.yaml", {
      version = var.operation_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_operation_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Operation"
  namespaces    = ["operation"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_operation_application
  ]
}

/******************************************
  Helm Orchestrator
  *****************************************/

module "helm_orchestrator_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/orchestrator"
  name                 = "orchestrator"
  chart_version        = var.orchestrator_chart_version
  namespace            = "orchestrator"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/orchestrator/values-orchestrator-vnext.yaml", {
      version = var.orchestrator_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_orchestrator_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Orchestrator"
  namespaces    = ["orchestrator"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_orchestrator_application
  ]
}

/******************************************
  Helm Person
  *****************************************/

module "helm_person_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/person"
  name                 = "person"
  chart_version        = var.person_chart_version
  namespace            = "person"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/person/values-person-vnext.yaml", {
      version = var.person_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_person_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Person"
  namespaces    = ["person"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_person_application
  ]
}

/******************************************
  Helm Piercards
  *****************************************/

module "helm_piercards_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/piercards"
  name                 = "piercards"
  chart_version        = var.piercards_chart_version
  namespace            = "piercards"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/piercards/values-piercards-vnext.yaml", {
      version = var.piercards_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_piercards_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Piercards"
  namespaces    = ["piercards"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_piercards_application
  ]
}

/******************************************
  Helm Product
  *****************************************/
module "helm_product_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/product"
  name                 = "product"
  chart_version        = var.product_chart_version
  namespace            = "product"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/product/values-product-vnext.yaml", {
      version = var.product_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_product_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Product"
  namespaces    = ["product"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_product_application
  ]
}

/******************************************
  Helm Statement
  *****************************************/

module "helm_statement_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/statement"
  name                 = "statement"
  chart_version        = var.statement_chart_version
  namespace            = "statement"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/statement/values-statement-vnext.yaml", {
      version = var.statement_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_statement_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Statement"
  namespaces    = ["statement"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_statement_application
  ]
}

/******************************************
  Helm Transaction
  *****************************************/

module "helm_transaction_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/transaction"
  name                 = "transaction"
  chart_version        = var.transaction_chart_version
  namespace            = "transaction"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/transaction/values-transaction-vnext.yaml", {
      version = var.transaction_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_transaction_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Transaction"
  namespaces    = ["transaction"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_transaction_application
  ]
}

/******************************************
  Helm Vhub
  *****************************************/

module "helm_vhub_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/vhub"
  name                 = "vhub"
  chart_version        = var.vhub_chart_version
  namespace            = "vhub"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/vhub/values-vhub-vnext.yaml", {
      version = var.vhub_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_vhub_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Vhub"
  namespaces    = ["vhub"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_vhub_application
  ]
}

/******************************************
  Helm Bankslip
  *****************************************/

module "helm_bankslip_application" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/bankslip"
  name                 = "bankslip"
  chart_version        = var.bankslip_chart_version
  namespace            = "bankslip"
  create_namespace_app = true
  values_contents = [
    templatefile("../../../helm/application/bankslip/values-bankslip-vnext.yaml", {
      version = var.bankslip_version
    })
  ]

  depends_on = [
    kubectl_manifest.istio
  ]
}

module "rancher_bankslip_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "Bankslip"
  namespaces    = ["bankslip"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    module.helm_bankslip_application
  ]
}