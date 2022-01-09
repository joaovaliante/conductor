/******************************************
  Event Hub
 *****************************************/
module "event_hub" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/azure/application/event-hub"

  name                = "event-hub-splunk"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  zone_redundant      = true
  auto_scale          = true
  capacity            = 1
  max_capacity        = 10

  hubs = {
    "logs-pier" = {
      partition_count = 10
      retention       = 1
      consumers       = ["splunk"]
    }
  }

  rules = {
    "splunk" = {
      listen = true
      send   = true
      manage = true
    }
  }

  tags = merge(var.tags, {
    "Application" = "EventHub"
  })
}