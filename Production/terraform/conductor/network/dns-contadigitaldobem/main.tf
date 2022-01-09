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
    values = [{ value = "201.20.14.14" }]
    }, {
    name = "@"
    type = "MX"
    values = [{
      preference = "0"
      value = "contadigitaldobem-com-br.mail.protection.outlook.com" }]
    }, {
    name = "@"
    type = "TXT"
    values = [
      { value = "MS=ms21014058" },
    { value = "v=spf1 include:spf.protection.outlook.com -all" }]
    }, {
    name   = "selector1._domainkey"
    type   = "CNAME"
    values = [{ value = "selector1-contadigitaldobem-com-br._domainkey.Conductor.onmicrosoft.com" }]
    }, {
    name   = "selector2._domainkey"
    type   = "CNAME"
    values = [{ value = "selector2-contadigitaldobem-com-br._domainkey.Conductor.onmicrosoft.com" }]
    }, {
    name   = "autodiscover"
    type   = "CNAME"
    values = [{ value = "autodiscover.outlook.com" }]
    }, {
    name   = "www"
    type   = "A"
    values = [{ value = "201.20.14.14" }]
  }]

  depends_on = [
    azurerm_dns_zone.dns_zone,
    google_dns_managed_zone.dns_zone,
  ]
}