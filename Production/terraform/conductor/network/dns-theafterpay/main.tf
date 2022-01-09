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
    values = [{ value = "35.196.200.47" }]
    }, {
    name = "@"
    type = "TXT"
    values = [
      { value = "mpw1txnbwhwx4n15740m5njrk2s15r5f" },
    { value = "v=spf1 -all" }]
    }, {
    name   = "_domainconnect"
    type   = "CNAME"
    values = [{ value = "_domainconnect.gd.domaincontrol.com" }]
    }, {
    name   = "asuid"
    type   = "TXT"
    values = [{ value = "4ED6CC537FF97C4CACA0FD7EDF04025DF72EF55BC4FBA100BE9FA50386EF59E0" }]
    }, {
    name   = "bxhgahhzl73m7hswrs8n"
    type   = "CNAME"
    values = [{ value = "verify.squarespace.com" }]
    }, {
    name   = "www"
    type   = "CNAME"
    values = [{ value = "theafterpay.wpengine.com" }]
  }]

  depends_on = [
    azurerm_dns_zone.dns_zone,
    google_dns_managed_zone.dns_zone,
  ]
}