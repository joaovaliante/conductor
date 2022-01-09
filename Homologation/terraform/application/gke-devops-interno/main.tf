/******************************************
	Locals
 *****************************************/

/******************************************
	Data Source
 *****************************************/
module "kubernetes" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/data/cluster"

  project      = var.project
  cluster_name = var.cluster_name
  region       = var.region
}

/******************************************
	Helm 
 *****************************************/
module "ingress_nginx" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/ingress-nginx"

  values_contents = [
    file("../../../helm/google/ingress/values-ingress-nginx-local.yaml")
  ]

  depends_on = [
    module.kubernetes
  ]
}

resource "helm_release" "rundeck" {
  name             = "rundeck"
  repository       = "https://cdt-helm-application.storage.googleapis.com"
  chart            = "rundeck"
  namespace        = "rundeck"
  create_namespace = true
  values = [
    templatefile("../../../helm/rundeck/values.yaml", {
      certValue        = var.cert_value
      certKeyValue     = var.cert_key_value
      registryPassword = var.registry_password
      storageAccessKey = var.storage_access_key
      ldapPassword     = var.ldap_password
    }),
    file("../../../helm/rundeck/values-devcdt.yaml")
  ]

  depends_on = [
    module.ingress_nginx
  ]
}