/******************************************
  Local
 *****************************************/
locals {
  labels = {
    for key, value in var.tags : lower(key) => replace(lower(value), " ", "_")
  }
}

/******************************************
  DNS Zones
 *****************************************/
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "google_dns_managed_zone" "dns_zone" {
  name        = var.dns_zone_name
  project     = var.project
  dns_name    = "${var.dns_name}."
  description = var.dns_zone_description
  labels      = local.labels
}

/******************************************
  DNS Records
 *****************************************/
module "dns_record" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/conductor/network/dns-records"

  dns_name            = var.dns_name
  dns_zone_name       = var.dns_zone_name
  resource_group_name = var.resource_group_name
  project             = var.project
  tags                = {}

  records = [{
    name   = "@"
    type   = "A"
    values = [{ value = "52.67.40.16" }]
    }, {
    name   = "@"
    type   = "TXT"
    values = [{ value = "2eaa6cbaab184c5592c32839c3728bd4" }]
    }, {
    name   = "www"
    type   = "A"
    values = [{ value = "52.67.40.16" }]
  }]

  depends_on = [
    azurerm_dns_zone.dns_zone,
    google_dns_managed_zone.dns_zone,
  ]
}