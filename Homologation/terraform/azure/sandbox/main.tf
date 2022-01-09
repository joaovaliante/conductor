data "azurerm_key_vault" "sandbox-dock-gke" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_certificate" "devcdt" {
  name         = "devcdt"
  key_vault_id = data.azurerm_key_vault.sandbox-dock-gke.id
}

/******************************************
	Front-Door
 *****************************************/
module "front_door_sandbox" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/network/frontdoor"

  name                = "sandbox-cdt"
  resource_group_name = var.resource_group_name
  tags                = var.tags

  frontends = [{
    name         = "sandbox-dock-gke"
    hostname     = "sandbox-dock.devcdt.com.br"
    custom_https = true
    https = {
      source        = "AzureKeyVault"
      vault_id      = data.azurerm_key_vault.sandbox-dock-gke.id
      vault_secret  = data.azurerm_key_vault_certificate.devcdt.name
      vault_version = data.azurerm_key_vault_certificate.devcdt.version
    }
    }, {
    name         = "sandbox-cdt"
    hostname     = "sandbox-cdt.azurefd.net"
    custom_https = false
    https        = {}
  }]

  backends = [{
    name                = "sandbox-dock-gke"
    loadbalance_success = 3
    loadbalance_latency = 200
    health_probe_path   = "/v2/monitor/health"
    servers = [{
      address     = var.sandbox_dock_gke_address
      host_header = "sandbox-dock.devcdt.com.br"
      http_port   = 80
      https_port  = 443
      weight      = 100
    }]
  }]

  routes = [{
    name      = "sandbox-dock-gke"
    protocols = ["Https"]
    frontends = ["sandbox-dock-gke"]
    patterns  = ["/v2/*"]
    forwarding = {
      backend_name = "sandbox-dock-gke"
      protocol     = "HttpOnly"
    }
  }]
}