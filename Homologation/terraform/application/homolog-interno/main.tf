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
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/kubernetes/data/cluster"

  project      = var.project
  cluster_name = var.cluster_name
  region       = var.region
}

/******************************************
	Helm - Pier CDC
 *****************************************/
module "helm_cdc_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  heimdall_enabled               = false
  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  pier_release_name              = "pier-cdc"
  pier_version                   = var.pier_version
  pier_new_version               = var.pier_new_version
  pier_min_replicas              = 1
  pier_max_replicas              = 20
  pier_chart_version             = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi-cdc.yaml", {
      node_name        = "cdc"
      ingress_class    = "nginx"
      pier_dns         = var.pier_cdc_dns
      pier_environment = "HOMOLOG-INTERNO-CDC"
    }),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

/******************************************
	Helm - Pier Stress
 *****************************************/
module "helm_pier_stress_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  heimdall_enabled               = false
  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  pier_release_name              = "pier-stress"
  pier_version                   = var.pier_version
  pier_new_version               = var.pier_new_version
  pier_min_replicas              = 1
  pier_max_replicas              = 5
  pier_chart_version             = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi.yaml", {
      pier_image = "conductorcr.azurecr.io/pierlabs-candidate/pier-api"
    }),
    file("../../../helm/application/pier/values-pier-hmlgi-stress.yaml"),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

module "rancher_cdc_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/application"

  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  heimdall_enabled          = false
  pier_enabled              = true
  rancher_pier_project_name = "cdc"
  pier_namespaces           = ["pier-cdc", "pier-cdc-redis", "pier-cdc-rabbitmq", "pier-stress"]

  depends_on = [
    module.helm_cdc_application,
    module.helm_pier_stress_application
  ]
}

/******************************************
  Helm - Rabbitmq
 *****************************************/
resource "helm_release" "rabbitmq_default" {

  name             = "rabbitmq"
  repository       = "https://cdt-helm-application.storage.googleapis.com"
  chart            = "rabbitmq"
  version          = "0.3.5"
  namespace        = "rabbitmq-default"
  create_namespace = true

  values = [
    file("../../../helm/application/rabbitmq/values-rabbitmq-hmlgi.yaml"),
    templatefile("../../../helm/google/rabbitmq/values-rabbitmq.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

module "rancher_rabbitmq_default" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Rabbitmq"
  namespaces    = ["rabbitmq-default"]

  depends_on = [
    helm_release.rabbitmq_default
  ]
}

/******************************************
	Helm - Redis Default
 *****************************************/
module "helm_redis" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/redis"

  name      = "redis"
  namespace = "redis-default"

  values_contents = [
    file("../../../helm/application/redis/values-redis.yaml")
  ]
}

module "rancher_redis" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Redis"
  namespaces    = ["redis-default"]

  depends_on = [
    module.helm_redis
  ]
}

/******************************************
  Helm - Heimdall & Pier
 *****************************************/
module "helm_hp_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  ingress_nginx_enabled          = true
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml")
  ]

  heimdall_release_name         = "heimdall-hmlgi-hp"
  heimdall_enabled              = var.hp_heimdall_enabled
  heimdall_version              = var.hp_heimdall_gateway_version
  heimdall_new_version          = var.hp_heimdall_new_version
  heimdall_min_replicas         = 1
  heimdall_max_replicas         = 3
  heimdall_new_version_replicas = var.hp_heimdall_new_version_replicas
  heimdall_chart_version        = var.hp_heimdall_chart_version

  heimdall_values_contents = [
    templatefile("../../../helm/application/heimdall/values-heimdall-hmlgi.yaml", {
      api_image        = "conductorcr.azurecr.io/heimdall-api-hmlg/heimdall-api"
      api_version      = "2.17.1-SNAPSHOT"
      frontend_image   = "conductorcr.azurecr.io/heimdall-frontend-hmlg/heimdall-frontend"
      frontend_version = "2.19.1-SNAPSHOT"
      gateway_image    = "conductorcr.azurecr.io/heimdall-gateway-hmlg/heimdall-gateway"
    }),
    file("../../../helm/application/heimdall/values-heimdall-hmlgi-hp.yaml"),
    file("../../../helm/google/heimdall/values-heimdall.yaml")
  ]

  pier_release_name  = "pier-hmlgi-hp"
  pier_enabled       = var.hp_pier_enabled
  pier_version       = var.hp_pier_version
  pier_new_version   = var.hp_pier_new_version
  pier_min_replicas  = 1
  pier_max_replicas  = 3
  pier_chart_version = var.hp_pier_chart_version

  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi.yaml", {
      pier_image = "conductorcr.azurecr.io/pierlabs-hmlg/pier-api"
    }),
    file("../../../helm/application/pier/values-pier-hmlgi-hp.yaml"),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

module "helm_pier_candidate_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  heimdall_enabled               = false
  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key

  pier_release_name  = "pier-hmlgi-hp-candidate"
  pier_enabled       = var.hp_pier_enabled
  pier_version       = var.hp_pier_version
  pier_new_version   = var.hp_pier_new_version
  pier_min_replicas  = 1
  pier_max_replicas  = 3
  pier_chart_version = var.hp_pier_chart_version

  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi.yaml", {
      pier_image = "conductorcr.azurecr.io/pierlabs-candidate/pier-api"
    }),
    file("../../../helm/application/pier/values-pier-hmlgi-hp-candidate.yaml"),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

/******************************************
  Project - HP - NEO
 *****************************************/
resource "kubernetes_namespace" "neo_hp" {
  metadata {
    name = "neo-hmlgi-hp"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

module "rancher_hp_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Heimdall-pier"
  namespaces    = ["heimdall-hmlgi-hp", "pier-hmlgi-hp", "pier-hmlgi-hp-candidate", "neo-hmlgi-hp"]

  depends_on = [
    module.helm_hp_application,
    module.helm_pier_candidate_application,
    kubernetes_namespace.neo_hp
  ]
}

/******************************************
  Helm - Jarvis & Kafka Fraude
 *****************************************/
module "helm_kafka_jarvis_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/kafka"

  kafka_version       = var.kafka_version
  kafka_chart_version = var.kafka_chart_version
  kafka_namespace     = "kafka-jarvis"

  kafka_values_contents = [
    file("../../../helm/application/jarvis-kafka/values-kafka-hmlgi-jarvis.yaml"),
    file("../../../helm/google/jarvis-kafka/values-kafka.yaml")
  ]
  wait_install = false
}

/******************************************
  Helm - Mongodb Jarvis Fraude
 *****************************************/
module "helm_jarvis_mongodb_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mongodb"

  name      = "mongo-db"
  namespace = "mongodb-hmlgi-jarvis"

  values_contents = [
    templatefile("../../../helm/application/mongodb/values-mongodb-hmlgi-jarvis.yaml", {
      registry_password = var.registry_password
    }),
    file("../../../helm/google/mongodb/values-mongodb.yaml")
  ]
}

/******************************************
  Helm - Mssql Jarvis Fraude
 *****************************************/
module "helm_jarvis_mssql_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mssql"

  name      = "mssql-server"
  namespace = "mssql-hlmgi-jarvis"

  values_contents = [
    templatefile("../../../helm/application/mssql/values-mssql-hmlgi-jarvis.yaml", {
      registry_password = var.registry_password
      }
    ),
    file("../../../helm/google/mssql/values-mssql.yaml")
  ]
}

/******************************************
  Rancher - Jarvis & Kafka Fraude
 *****************************************/
module "rancher_jarvis_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Jarvis"
  namespaces    = ["jarvis", "kafka-jarvis", "mongodb-jarvis", "mssql-jarvis"]

  depends_on = [
    module.helm_kafka_jarvis_application,
    module.helm_jarvis_mongodb_application,
    module.helm_jarvis_mssql_application
  ]
}

/******************************************
  Helm - Jarvis & Kafka QA
 *****************************************/
module "helm_kafka_qa_jarvis_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/kafka"

  kafka_name          = "kafka-qa"
  kafka_version       = var.kafka_version
  kafka_chart_version = var.kafka_chart_version
  kafka_namespace     = "kafka-jarvis-qa"

  kafka_values_contents = [
    file("../../../helm/application/jarvis-kafka/values-kafka-hmlgi-jarvis-qa.yaml"),
    file("../../../helm/google/jarvis-kafka/values-kafka.yaml")
  ]
  wait_install = false
}

/******************************************
  Helm - Mongodb Jarvis QA
 *****************************************/
module "helm_jarvis_mongodb_qa_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/mongodb"

  name      = "mongo-db"
  namespace = "mongodb-jarvis-qa"

  values_contents = [
    templatefile("../../../helm/application/mongodb/values-mongodb-hmlgi-jarvis.yaml", {
      registry_password = var.registry_password
    }),
    file("../../../helm/google/mongodb/values-mongodb.yaml")
  ]
}

/******************************************
  Rancher - Jarvis & Kafka QA
 *****************************************/
module "rancher_jarvis_qa_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Jarvis-QA"
  namespaces    = ["jarvis-qa", "kafka-jarvis-qa", "mongodb-jarvis-qa"]

  depends_on = [
    module.helm_kafka_qa_jarvis_application,
    module.helm_jarvis_mongodb_application,
  ]
}

/******************************************
  Helm - SGR-STORE Application
 *****************************************/
module "helm_store_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/sgr-store"

  name          = "store-hmlgi"
  namespace     = "store-hmlgi"
  chart_version = var.store_chart_version

  values_contents = [
    templatefile("../../../helm/application/store/values-store-hmlgi.yaml", {
      image   = "conductorcr.azurecr.io/store/store-api"
      version = "1.12.5"
    })
  ]
}

module "rancher_store_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Store"
  namespaces    = ["store-hmlgi"]

  depends_on = [
    module.helm_store_application
  ]
}

/******************************************
	Harness
 *****************************************/
module "harness" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/kubernetes/harness"
}


/******************************************
  Helm - SGR
 *****************************************/
/*
module "helm_sgr_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/sgr"
  values_contents = [
    templatefile("../../../helm/application/sgr/values-sgr-hmli.yaml", {
      image                   = "conductorcr.azurecr.io/sgr/sgr-core"
      version                 = "5.1.6"
      registry_password       = var.registry_password
    })
  ]
}

module "rancher_sgr_application" {
  source        = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"
  cluster_name  = var.cluster_name
  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  project       = "SGR"
  namespaces    = ["sgr-hmlg"]

  depends_on = [
    module.helm_sgr_application
  ]
}
*/

/******************************************
  Namespace - SQA CANDIDATE - NEO
 *****************************************/
resource "kubernetes_namespace" "neo_sqa_candidate" {
  metadata {
    name = "sqa-candidate-neo"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Helm - SQA CANDIDATE Heimdall & Pier
 *****************************************/
module "helm_sqa_candidate_pier_heimdall_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml")
  ]

  heimdall_release_name         = "sqa-candidate-heimdall"
  heimdall_enabled              = var.heimdall_enabled
  heimdall_new_version          = var.heimdall_new_version
  heimdall_version              = var.heimdall_version_gateway
  heimdall_max_replicas         = 4
  heimdall_min_replicas         = var.heimdall_replicas
  heimdall_new_version_replicas = var.heimdall_new_version_replicas
  heimdall_chart_version        = var.heimdall_chart_version
  heimdall_values_contents = [
    templatefile("../../../helm/application/heimdall/values-heimdall-hmlgi.yaml", {
      api_image        = "conductorcr.azurecr.io/heimdall-api-hmlg/heimdall-api"
      api_version      = "2.7.4-SNAPSHOT"
      frontend_image   = "conductorcr.azurecr.io/heimdall-frontend-hmlg/heimdall-frontend"
      frontend_version = "2.7.4-SNAPSHOT"
      gateway_image    = "conductorcr.azurecr.io/heimdall-gateway-hmlg/heimdall-gateway"
    }),
    file("../../../helm/application/heimdall/values-heimdall-hmlgi-sqa.yaml"),
    file("../../../helm/google/heimdall/values-heimdall.yaml")
  ]

  pier_release_name  = "pier-hmlgi-sqa-candidate"
  pier_version       = "2.206.0"
  pier_new_version   = var.pier_new_version
  pier_min_replicas  = 1
  pier_max_replicas  = 3
  pier_chart_version = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi.yaml", {
      pier_image = "conductorcr.azurecr.io/pierlabs-candidate/pier-api"
    }),
    file("../../../helm/application/pier/values-pier-hmlgi-sqa-candidate.yaml"),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}


/******************************************
  Namespace - SQA CANDIDATE - Loki
 *****************************************/
resource "kubernetes_namespace" "loki_sqa_candidate" {
  metadata {
    name = "sqa-candidate-loki"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}


/******************************************
  Namespace - Iris SQA Candidate
 *****************************************/
resource "kubernetes_namespace" "sqa_iris_candidate" {
  metadata {
    name = "sqa-candidate-iris"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Rancher - SQA-CANDIDATE
 *****************************************/
module "rancher_sqa_candidate_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name

  project    = "Sqa-candidate"
  namespaces = ["sqa-candidate-neo", "sqa-candidate-heimdall", "pier-hmlgi-sqa-candidate", "sqa-candidate-loki", "sqa-candidate-iris", "sqa-loki-redis"]

  depends_on = [
    kubernetes_namespace.neo_sqa_candidate,
    module.helm_sqa_candidate_pier_heimdall_application,
    kubernetes_namespace.loki_sqa_candidate,
    kubernetes_namespace.sqa_iris_candidate
  ]
}

/******************************************
  Namespace - SQA HOMOLOG - NEO
 *****************************************/
resource "kubernetes_namespace" "neo_sqa_hmlg" {
  metadata {
    name = "sqa-hmlg-neo"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Helm - SQA HMLG Heimdall & Pier
 *****************************************/
module "helm_sqa_hmlg_pier_heimdall_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml")
  ]

  heimdall_release_name         = "sqa-hmlg-heimdall"
  heimdall_enabled              = var.heimdall_enabled
  heimdall_new_version          = var.heimdall_new_version
  heimdall_version              = var.heimdall_version_gateway
  heimdall_max_replicas         = 4
  heimdall_min_replicas         = var.heimdall_replicas
  heimdall_new_version_replicas = var.heimdall_new_version_replicas
  heimdall_chart_version        = var.heimdall_chart_version
  heimdall_values_contents = [
    templatefile("../../../helm/application/heimdall/values-heimdall-hmlgi.yaml", {
      api_image        = "conductorcr.azurecr.io/heimdall-api-hmlg/heimdall-api"
      api_version      = "2.7.4-SNAPSHOT"
      frontend_image   = "conductorcr.azurecr.io/heimdall-frontend-hmlg/heimdall-frontend"
      frontend_version = "2.7.4-SNAPSHOT"
      gateway_image    = "conductorcr.azurecr.io/heimdall-gateway-hmlg/heimdall-gateway"
    }),
    file("../../../helm/application/heimdall/values-heimdall-hmlgi-sqa.yaml"),
    file("../../../helm/google/heimdall/values-heimdall.yaml")
  ]

  pier_release_name  = "pier-hmlgi-sqa-hmlg"
  pier_version       = "2.206.0"
  pier_new_version   = var.pier_new_version
  pier_min_replicas  = 1
  pier_max_replicas  = 3
  pier_chart_version = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi.yaml", {
      pier_image = "conductorcr.azurecr.io/pierlabs-hmlg/pier-api"
    }),
    file("../../../helm/application/pier/values-pier-hmlgi-sqa-hmlg.yaml"),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

/******************************************
  Namespace - SQA HMLG - Loki
 *****************************************/
resource "kubernetes_namespace" "loki_sqa_hmlg" {
  metadata {
    name = "sqa-hmlg-loki"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Namespace - Iris SQA Hmlg
 *****************************************/
resource "kubernetes_namespace" "sqa_iris_hmlg" {
  metadata {
    name = "sqa-hmlg-iris"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/*****************************************
  Rancher - SQA HMLG
 *****************************************/
module "rancher_sqa_hmlg_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Sqa-hmlg"
  namespaces    = ["sqa-hmlg-neo", "sqa-hmlg-heimdall", "pier-hmlgi-sqa-hmlg", "sqa-hmlg-loki", "sqa-hmlg-iris", "sqa-loki-redis"]

  depends_on = [
    kubernetes_namespace.neo_sqa_hmlg,
    module.helm_sqa_hmlg_pier_heimdall_application,
    kubernetes_namespace.loki_sqa_hmlg,
    kubernetes_namespace.sqa_iris_hmlg
  ]
}

/******************************************
  Helm - Project Iris Heimdall & Pier
 *****************************************/
module "helm_iris_pier_heimdall_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/helm/application"

  ingress_nginx_enabled          = false
  ingress_nginx_pier_enabled     = false
  ingress_nginx_default_tls_cert = var.ingress_nginx_default_tls_cert
  ingress_nginx_default_tls_key  = var.ingress_nginx_default_tls_key
  ingress_nginx_values_contents = [
    file("../../../helm/application/ingress/values-ingress-nginx.yaml"),
    file("../../../helm/application/ingress/values-ingress-nginx-internal.yaml")
  ]

  heimdall_release_name         = "iris-heimdall"
  heimdall_enabled              = var.heimdall_enabled
  heimdall_new_version          = var.heimdall_new_version
  heimdall_version              = var.heimdall_version_gateway
  heimdall_max_replicas         = 4
  heimdall_min_replicas         = var.heimdall_replicas
  heimdall_new_version_replicas = var.heimdall_new_version_replicas
  heimdall_chart_version        = var.heimdall_chart_version
  heimdall_values_contents = [
    templatefile("../../../helm/application/heimdall/values-heimdall-hmlgi.yaml", {
      api_image        = "conductorcr.azurecr.io/heimdall-api-hmlg/heimdall-api"
      api_version      = "2.7.4-SNAPSHOT"
      frontend_image   = "conductorcr.azurecr.io/heimdall-frontend-hmlg/heimdall-frontend"
      frontend_version = "2.7.4-SNAPSHOT"
      gateway_image    = "conductorcr.azurecr.io/heimdall-gateway-hmlg/heimdall-gateway"
    }),
    file("../../../helm/application/heimdall/values-heimdall-hmlgi-iris.yaml"),
    file("../../../helm/google/heimdall/values-heimdall.yaml")
  ]

  pier_release_name  = "pier-hmlgi-iris"
  pier_version       = "2.205.0"
  pier_new_version   = var.pier_new_version
  pier_min_replicas  = 1
  pier_max_replicas  = 3
  pier_chart_version = var.pier_chart_version
  pier_values_contents = [
    templatefile("../../../helm/application/pier/values-pier-hmlgi.yaml", {
      pier_image = "conductorcr.azurecr.io/pierlabs-hmlg/pier-api"
    }),
    file("../../../helm/application/pier/values-pier-hmlgi-iris.yaml"),
    templatefile("../../../helm/google/pier/values-pier.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

/******************************************
  Namespace - Iris - Loki
 *****************************************/
resource "kubernetes_namespace" "iris_loki" {
  metadata {
    name = "iris-loki"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Namespace - Iris Hmlg
 *****************************************/
resource "kubernetes_namespace" "iris_hmlg" {
  metadata {
    name = "iris-hmlg"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Namespace - Iris Candidate
 *****************************************/
resource "kubernetes_namespace" "iris_candidate" {
  metadata {
    name = "iris-candidate"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Rancher - Project Iris
 *****************************************/
module "rancher_iris_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "Iris"
  namespaces    = ["iris-heimdall", "pier-hmlgi-iris", "iris-loki", "iris-hmlg", "iris-candidate"]

  depends_on = [
    kubernetes_namespace.iris_hmlg,
    kubernetes_namespace.iris_candidate,
    kubernetes_namespace.iris_loki,
    module.helm_iris_pier_heimdall_application
  ]
}

/******************************************
  Namespace - Thor
 *****************************************/
resource "kubernetes_namespace" "thor_app" {
  metadata {
    name = "thor"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Helm Release - Rabbit Thor
 *****************************************/
resource "helm_release" "rabbitmq_thor" {

  name             = "rabbitmq"
  repository       = "https://cdt-helm-application.storage.googleapis.com"
  chart            = "rabbitmq"
  version          = "0.3.5"
  namespace        = "rabbitmq-thor"
  create_namespace = true

  values = [
    file("../../../helm/application/rabbitmq/values-rabbitmq-hmlgi.yaml"),
    templatefile("../../../helm/google/rabbitmq/values-rabbitmq.yaml", {
      cluster_name = var.cluster_name
    })
  ]
}

/******************************************
  Rancher - Project Thor
 *****************************************/
module "rancher_thor_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "thor"
  namespaces    = ["thor", "rabbitmq-thor"]

  depends_on = [
    kubernetes_namespace.thor_app,
    helm_release.rabbitmq_thor
  ]
}

/******************************************
  Namespace - Thor Qa
 *****************************************/
resource "kubernetes_namespace" "thor_qa" {
  metadata {
    name = "thor-qa"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

/******************************************
  Rancher - Project Thor QA
 *****************************************/
module "rancher_thor_qa_application" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/rancher/project"

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token
  cluster_name  = var.cluster_name
  project       = "thor-qa"
  namespaces    = ["thor-qa"]

  depends_on = [
    kubernetes_namespace.thor_qa
  ]
}