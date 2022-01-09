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
	Ingress NGINX
 *****************************************/
module "ingress_nginx" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/ingress-nginx"

  replicas      = 2
  minReplicas   = 2
  chart_version = "3.23.0"
  values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-default-cert.yaml"),
    file("../../../helm/azure/ingress/values-ingress-nginx.yaml")
  ]

  depends_on = [
    module.kubernetes
  ]
}

resource "kubernetes_secret" "default-tls" {
  metadata {
    name      = "default-tls"
    namespace = "ingress-nginx"
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = base64decode(var.rancher_tls_cert)
    "tls.key" = base64decode(var.rancher_tls_key)
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
	Rancher
 *****************************************/
resource "kubernetes_namespace" "rancher" {
  metadata {
    name = var.rancher_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "kubernetes_secret" "rancher_tls" {
  metadata {
    name      = "tls-rancher-ingress"
    namespace = var.rancher_namespace
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = base64decode(var.rancher_tls_cert)
    "tls.key" = base64decode(var.rancher_tls_key)
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "helm_release" "rancher" {
  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  chart      = "rancher"
  namespace  = var.rancher_namespace
  values = [
    templatefile("../../../helm/application/rancher/values.yaml", {
      rancher_hostname = var.rancher_hostname
      rancher_version  = var.rancher_version
    })
  ]

  depends_on = [
    module.ingress_nginx,
    kubernetes_namespace.rancher
  ]
}

/******************************************
	Mimir
 *****************************************/
resource "helm_release" "mimir" {
  name             = "mimir"
  repository       = "https://cdt-helm-application.storage.googleapis.com"
  chart            = "mimir"
  wait             = true
  namespace        = "mimir"
  version          = ""
  create_namespace = true
  values = [
    templatefile("../../../helm/application/mimir/values.yaml", {
      registry_password           = var.registry_password
      keyVault_url                = var.mimir_keyVault_url
      apim_url                    = var.mimir_apim_url
      client_id                   = var.mimir_client_id
      tenant_id                   = var.mimir_tenant_id
      client_secret               = var.mimir_client_secret
      subscription_id             = var.mimir_subscription_id
      apim_subscription_primary   = var.mimir_apim_subscription_primary
      apim_subscription_secondary = var.mimir_apim_subscription_secondary
      auth_sensedia               = var.mimir_auth_sensedia
      authentication_key          = var.mimir_authentication_key
      key_salt                    = var.mimir_key_salt
    }),
    file("../../../helm/azure/mimir/values.yaml")
  ]
}

module "rancher_mimir" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "mimir"
  namespaces    = ["mimir"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    helm_release.mimir
  ]
}

/******************************************
	Harness
 *****************************************/
resource "helm_release" "harness_delegate" {
  name       = "harness-delegate"
  repository = "https://app.harness.io/storage/harness-download/harness-helm-charts"
  chart      = "harness-delegate"
  values = [
    templatefile("../../../helm/application/harness/delegate-values.yaml", {
      accountId       = var.harness_account_id
      accountSecret   = var.harness_account_secret
      delegateName    = "production-kubernetes-azure"
      delegateProfile = var.harness_delegate_profile
    })
  ]
}

module "rancher_harness" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  project       = "harness"
  namespaces    = ["harness-delegate"]
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  depends_on = [
    helm_release.harness_delegate
  ]
}

/******************************************
	AutoSeg
 *****************************************/
module "autoseg" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/autoseg"

  name = "autoseg"
  namespace = "autoseg"

  values_contents = [
    templatefile("../../../helm/application/autoseg/values-autoseg.yaml", {
      registry_password = var.registry_password
    })
  ]
}

module "autoseg_namespace" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "autoseg"
  namespaces    = ["autoseg"]

  depends_on = [
    module.autoseg
  ]
}