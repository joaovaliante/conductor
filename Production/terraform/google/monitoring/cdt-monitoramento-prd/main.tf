/******************************************
	Recursos básicos
 *****************************************/
module "base-project" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/project"

  project = var.project
}

/******************************************
	Locals
 *****************************************/
locals {
  ssh_keys = [{
    user : "admin_prd"
    key : file("~/.ssh/id_rsa.pub")
    }, {
    user : "admin_prd"
    key : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ1k+nKtdgDCPB6J9pnQYDEiEoDf9f/jxAGCr47cw4JuJAuzUPRax77JQ/Z2OvCI9KFgbpgZyif7yI9sspysIHkUQMLw+9Y9KZm+UD1rCDXcyMSLq+AwJ5HZrPVSMZ6oBIpos94LHq6lYJIgF7tC96WIROGI98eU4zWDTBjNAmaP9sCHgKnT2f2Y1Fq2AdsQApZwDVmAjaeRFpvDquIIAOY41hfzRCriQyEYw3Ax3A5tMwBoWIuT75IhqNCCjUvMu4/9Yvc1M2gb73YmmqqLvW/7wJt9yNroDgXoR10PHRePvKurOV+JfvGjdZL7a+pTqIyvXVR0YJZDRCFIxTG9oD"
  }]
}

/******************************************
	Load Balance
 *****************************************/
module "gcp1p-splk-lb-1" {
  source = "./modules/splunk-lb"

  project               = var.project
  region                = var.region
  zone                  = "us-east1-b"
  host_vpc_name         = var.host_vpc_name
  host_subnet_name      = var.host_subnet_name
  host_network_project  = var.host_network_project
  timezone              = var.timezone
  disk_size             = 300
  labels                = var.labels
  certificate_key_path  = "/Users/SILVIO.JUNIOR/Downloads/Certificado 20-21 conductor.com.br/certificate.key"
  certificate_file_path = "/Users/SILVIO.JUNIOR/Downloads/Certificado 20-21 conductor.com.br/certificate.pem"

  instance_number      = "01"
  instance_internal_ip = "10.54.20.55"
  instance_ssh_keys    = local.ssh_keys

  loadbalance_ip   = "10.54.20.53"
  loadbalance_port = "8000"
}

module "gcp1p-splk-lb-group-zone-b" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-lb-zone-b"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-lb-1.self.self_link
  ]
}

module "gcp1p-splk-lb7-lb" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/internal-loadbalance"

  name    = "gcp1p-splk-lb7"
  region  = var.region
  project = var.project

  backends = [
    {
      description = "Instance group for Splunk LoadBalance L7 Zone B"
      group       = module.gcp1p-splk-lb-group-zone-b.self.self_link
    }
  ]

  ip_address           = "10.54.20.54"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  health_check_port    = 443
  http_health_check    = false
  ports                = ["443", "80"]
  create_firewall      = false # Using gcpinfra and infra on machine definition
}

/******************************************
	Search Head
 *****************************************/
module "gcp1p-splk-search-head-1" {
  source = "./modules/splunk-search-head"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size            = 300
  labels               = var.labels

  instance_number      = "01"
  instance_internal_ip = "10.54.20.31"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-search-head-2" {
  source = "./modules/splunk-search-head"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-c"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size            = 300
  labels               = var.labels

  instance_number      = "02"
  instance_internal_ip = "10.54.20.32"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-search-head-3" {
  source = "./modules/splunk-search-head"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-d"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size            = 300
  labels               = var.labels

  instance_number      = "03"
  instance_internal_ip = "10.54.20.33"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-search-head-4" {
  source = "./modules/splunk-search-head"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size            = 300
  labels               = var.labels

  instance_number      = "04"
  instance_internal_ip = "10.54.20.34"
  instance_ssh_keys    = local.ssh_keys
}

/******************************************
	Search Head Groups
 *****************************************/
module "gcp1p-splk-search-head-group-zone-b" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-sh-zone-b"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-search-head-4.self.self_link
  ]
}

module "gcp1p-splk-search-head-group-zone-c" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-sh-zone-c"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-c"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-search-head-2.self.self_link
  ]
}

module "gcp1p-splk-search-head-group-zone-d" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-sh-zone-d"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-d"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-search-head-3.self.self_link
  ]
}

/******************************************
	Search Head Load Balance
 *****************************************/
module "gcp1p-splk-search-head-lb" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/internal-loadbalance"

  name    = "gcp1p-splk-search-head-lb"
  region  = var.region
  project = var.project

  backends = [
    {
      description = "Instance group for Splunk Search Head Zone B"
      group       = module.gcp1p-splk-search-head-group-zone-b.self.self_link
    },
    {
      description = "Instance group for Splunk Search Head Zone C"
      group       = module.gcp1p-splk-search-head-group-zone-c.self.self_link
    },
    {
      description = "Instance group for Splunk Search Head Zone D"
      group       = module.gcp1p-splk-search-head-group-zone-d.self.self_link
    }
  ]

  ip_address           = "10.54.20.53"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  health_check_port    = 8000
  http_health_check    = false
  ports                = ["8000", "8089"]
  create_firewall      = false # Using gcpinfra and infra on machine definition
}

/******************************************
	Indexer
 *****************************************/
module "gcp1p-splk-indexer-1" {
  source = "./modules/splunk-indexer"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size_install    = 200
  disk_size_hot        = 2000
  disk_size_summary    = 1000
  disk_size_cold       = 12000
  labels               = var.labels

  instance_number      = "01"
  instance_internal_ip = "10.54.20.41"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-indexer-2" {
  source = "./modules/splunk-indexer"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-c"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size_install    = 200
  disk_size_hot        = 3000
  disk_size_cold       = 12000
  labels               = var.labels

  instance_number      = "02"
  instance_internal_ip = "10.54.20.42"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-indexer-3" {
  source = "./modules/splunk-indexer"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-d"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size_install    = 200
  disk_size_hot        = 3000
  disk_size_cold       = 12000
  labels               = var.labels

  instance_number      = "03"
  instance_internal_ip = "10.54.20.43"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-indexer-4" {
  source = "./modules/splunk-indexer"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size_install    = 200
  disk_size_hot        = 3000
  disk_size_cold       = 12000
  labels               = var.labels

  instance_number      = "04"
  instance_internal_ip = "10.54.20.44"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-indexer-5" {
  source = "./modules/splunk-indexer"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-c"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size_install    = 200
  disk_size_hot        = 3000
  disk_size_cold       = 12000
  labels               = var.labels

  instance_number      = "05"
  instance_internal_ip = "10.54.20.45"
  instance_ssh_keys    = local.ssh_keys
}

module "gcp1p-splk-indexer-6" {
  source = "./modules/splunk-indexer"

  project              = var.project
  region               = var.region
  zone                 = "us-east1-d"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  timezone             = var.timezone
  disk_size_install    = 200
  disk_size_hot        = 3000
  disk_size_cold       = 12000
  labels               = var.labels

  instance_number      = "06"
  instance_internal_ip = "10.54.20.46"
  instance_ssh_keys    = local.ssh_keys
}

/******************************************
	Indexer Groups
 *****************************************/
module "gcp1p-splk-indexer-group-zone-b" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-idx-zone-b"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-b"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-indexer-1.self.self_link,
    module.gcp1p-splk-indexer-4.self.self_link
  ]
}

module "gcp1p-splk-indexer-group-zone-c" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-idx-zone-c"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-c"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-indexer-2.self.self_link,
    module.gcp1p-splk-indexer-5.self.self_link
  ]
}

module "gcp1p-splk-indexer-group-zone-d" {
  source               = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-group-shared-vpc"
  name                 = "gcp1p-splk-idx-zone-d"
  project              = var.project
  region               = var.region
  zone                 = "us-east1-d"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project

  instances = [
    module.gcp1p-splk-indexer-3.self.self_link,
    module.gcp1p-splk-indexer-6.self.self_link
  ]
}
/******************************************
	Indexer Load Balance
 *****************************************/
module "gcp1p-splk-indexer-lb" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/network/internal-loadbalance"

  name    = "gcp1p-splk-indexer-lb"
  region  = var.region
  project = var.project

  backends = [
    {
      description = "Instance group for Splunk Indexer Zone B"
      group       = module.gcp1p-splk-indexer-group-zone-b.self.self_link
    },
    {
      description = "Instance group for Splunk Indexer Zone C"
      group       = module.gcp1p-splk-indexer-group-zone-c.self.self_link
    },
    {
      description = "Instance group for Splunk Indexer Zone D"
      group       = module.gcp1p-splk-indexer-group-zone-d.self.self_link
    }
  ]

  ip_address           = "10.54.20.52"
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  health_check_port    = 8000
  http_health_check    = false
  ports                = ["8000", "9997", "8088"]
  create_firewall      = false # Using gcpinfra and infra on machine definition
}
