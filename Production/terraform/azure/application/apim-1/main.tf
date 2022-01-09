/******************************************
  Data sources
 *****************************************/
data "azurerm_key_vault" "vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_certificate" "certificate" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_user_assigned_identity" "identity" {
  name                = var.user_identity
  resource_group_name = var.resource_group_name
}

/******************************************
  Event Hub
 *****************************************/
module "event_hub" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/event-hub"

  name                = "az1p-eventhub-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  zone_redundant      = true
  auto_scale          = true
  capacity            = 5
  max_capacity        = 20

  hubs = {
    "logs-gateway" = {
      partition_count = 10
      retention       = 1
      consumers       = ["splunk"]
    }
    "logs-cache" = {
      partition_count = 10
      retention       = 1
      consumers       = ["splunk"]
    }
    "logs-appgw-raw" = {
      partition_count = 10
      retention       = 1
      consumers       = ["splunk-appgw"]
    }
    "logs-appgw" = {
      partition_count = 10
      retention       = 1
      consumers       = ["splunk-appgw"]
    }
  }

  rules = {
    "apim" = {
      send = true
    }

    "appgw" = {
      send = true
    }

    "splunk" = {
      listen = true
      send   = true
      manage = true
    }

    "benthos" = {
      listen = true
      send   = true
    }
  }

  tags = merge(var.tags, {
    "Application" = "EventHub"
  })
}

/******************************************
  KeyVault
 *****************************************/
module "key_vault" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/security/key-vault"

  name                       = "az1p-gateway-data"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  soft_delete_retention_days = 90

  tags = merge(var.tags, {
    "Application" = "KeyVault"
  })
}

/******************************************
  Redis Cache
 *****************************************/
module "redis_storage" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/storage/storage-account"

  name                = "az1pgatewaycachestorage"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, {
    "Application" = "Redis - Storage"
  })
}

module "redis" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/cache/redis"

  name                                = "az1p-gateway-cache"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  family                              = "P"
  sku_name                            = "Premium"
  subnet_name                         = var.subnet_name_components
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name

  backup = {
    enabled                   = true
    storage_connection_string = module.redis_storage.primary_connection_string
  }

  firewall = {
    "apim" = {
      start_ip = "10.50.34.1"
      end_ip   = "10.50.34.254"
    }
  }

  tags = merge(var.tags, {
    "Application" = "Redis"
  })
}

/******************************************
  Web Application Firewall
 *****************************************/
module "waf" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/security/waf"

  name                = "az1p-gateway-appgw-waf"
  location            = var.location
  resource_group_name = var.resource_group_name

  policy = {
    mode = "Detection"
  }

  tags = merge(var.tags, {
    "Application" = "WAF"
  })
}

/******************************************
  API Management
 *****************************************/
module "apim-management-public-ip" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/network/public-ip"

  name                = "az1p-apim-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    "Application" = "API Management"
  })
}

module "apim" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/apim"

  name                                = "az1p-gateway-apim"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  subnet_name                         = var.subnet_name
  network_type                        = "Internal"
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  sku_name                            = "Premium"
  units                               = var.units
  publisher_email                     = "silvio.junior@conductor.com.br"
  publisher_name                      = "Silvio Assunção Junior"
  zones                               = ["1", "2", "3"]


  loggers = {
    "logger-eventhub-gateway" = {
      eventhub = {
        name       = "logs-gateway"
        connection = module.event_hub.rules_primary_connection_string[0]
      }
    }

    "logger-eventhub-cache" = {
      eventhub = {
        name       = "logs-cache"
        connection = module.event_hub.rules_primary_connection_string[0]
      }
    }
  }

  named_values = {
    "duration" = {
      value = var.cache_duration
    }

    "duration-invalid" = {
      value = var.cache_duration_invalid
    }

    "backend" = {
      value = var.backend_url
    }

    "backend-vnext-pierflex-account" = {
      value = var.backend_vnext_pierflex_account
    }

    "sync-url" = {
      value = var.mimir_url
    }

    "log-level" = {
      value = var.log_level
    }

    "apim-name" = {
      value = "APIM1"
    }

    "key-vault-name" = {
      value = "keyvault-apim-1"
    }

    "sync-authorization" = {
      value  = var.mimir_authorization
      secret = true
    }
  }

  tags = merge(var.tags, {
    "Application" = "API Management"
  })
}

module "apim-domain" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/apim-domain"

  api_management_name = module.apim.name
  resource_group_name = var.resource_group_name

  key_vault_name                = var.key_vault_name
  key_vault_resource_group_name = var.key_vault_resource_group_name
  manage_key_vault              = false

  proxies = [{
    hostname         = "gateway-apim-1.conductor.com.br"
    certificate_name = var.certificate_name
    }, {
    hostname         = var.dns_value
    certificate_name = var.certificate_name
  }]
}

module "api_cache" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/apim-api"

  name                = "cache-management"
  display_name        = "Cache management"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim.name
  path                = "apim/cache"
  protocols           = ["https"]
  subscription        = true

  operations = {
    sync = {
      display_name = "Sync"
      description  = "Syncronize cache entries"
      method       = "POST"
      url_path     = "/"
      policy       = file("../../../../apim/cache-management/sync.xml")
    }
    delete = {
      display_name = "Delete by clientId"
      description  = "Delete cache entry by clientId"
      method       = "DELETE"
      url_path     = "/{id}"
      policy       = file("../../../../apim/cache-management/delete.xml")
      parameters = {
        id = {
          required = true
          type     = "string"
        }
      }
    }
    get = {
      display_name = "Get by clientId"
      description  = "Get cache entry by clientId"
      method       = "GET"
      url_path     = "/{id}"
      policy       = file("../../../../apim/cache-management/get.xml")
      parameters = {
        id = {
          required = true
          type     = "string"
        }
      }
    }
  }
}

module "api_manager_health" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/apim-api"

  name                = "api-health"
  display_name        = "API Health Check"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim.name
  path                = "manager"
  protocols           = ["https"]
  policy              = file("../../../../apim/health-check/policy.xml")

  operations = {
    health = {
      display_name = "Health Check"
      description  = "Health Check"
      method       = "GET"
      url_path     = "/health"
    }
  }
}

module "api_pier" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/apim-api"

  name                = "pier"
  display_name        = "PIER Labs"
  description         = "API para integração com Aplicações de empresas Emissoras de Cartões de Crédito"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim.name
  path                = "pier"
  protocols           = ["https"]
  policy              = file("../../../../apim/authentication/policy.xml")
  // imports = [{
  //   format  = "swagger-json"
  //   content = file("../../../../apim/pier/pierlabs.swagger.json")
  // }]
}

module "api_vnext_account" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/apim-api"

  name                = "vnext_account"
  display_name        = "vNext Account API"
  description         = "API Account do vNext"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim.name
  path                = "account"
  protocols           = ["https"]
  policy              = file("../../../../apim/authentication-vnext/policy.xml")
   imports = [{
     format  = "swagger-json"
     content = file("../../../../apim/vnext-account-api/account-api.swagger.json")
   }]
}

/******************************************
  Application Gateway
 *****************************************/
module "application-gateway-ip" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/network/public-ip"

  name                = "az1p-gateway-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    "Application" = "Application Gateway"
  })
}

module "application-gateway" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/application-gateway"

  name                                = "az1p-gateway-appgw"
  sku                                 = "WAF_v2"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  subnet_name                         = var.application_gateway_subnet_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  min_capacity                        = 10
  max_capacity                        = 30
  zones                               = ["1", "2", "3"]
  identities                          = [data.azurerm_user_assigned_identity.identity.id]
  waf_id                              = module.waf.id

  waf = {
    enabled       = true
    firewall_mode = "Detection"
  }

  ip_configurations = {
    public = {
      public_ip_id = module.application-gateway-ip.id
    }
  }

  frontends = {
    https = {
      port             = 443
      ip_configuration = "public"
      protocol         = "Https"
      certificate = {
        name                 = "apim-https-certificate"
        certificate_vault_id = data.azurerm_key_vault_certificate.certificate.secret_id
      }
      ssl_policy = {
        name                 = "AppGwSslPolicy20170401S"
        min_protocol_version = "TLSv1_2"
      }
    }
  }

  backends = {
    apim = {
      port         = 443
      protocol     = "Https"
      hostname     = var.dns_value
      ip_addresses = module.apim.private_ip_addresses
      probe        = "apim"
    }
  }

  probes = {
    apim = {
      port              = 443
      protocol          = "Https"
      host_from_backend = true
      path              = "/status-0123456789abcdef"
    }
  }

  routes = {
    https = {
      backend = "apim"
    }
  }

  tags = merge(var.tags, {
    "Application" = "Application Gateway"
  })
}