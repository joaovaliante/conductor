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
    name = "@"
    type = "MX"
    values = [{
      preference = "10"
      value = "mail.pierlabs.io" }]
    }, {
    name = "@"
    type = "TXT"
    values = [
      { value = "f9r2wd916nmm30zx54lf0yv9wklgcv93" },
    { value = "\"v=spf1 a mx include:_spf.elasticemail.com include:zoho.com\"" }]
    }, {
    name   = "api._domainkey"
    type   = "TXT"
    values = [{ value = "k=rsa;t=s;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbmGbQMzYeMvxwtNQoXN0waGYaciuKx8mtMh5czguT4EZlJXuCt6V+l56mmt3t68FEX5JJ0q4ijG71BGoFRkl87uJi7LrQt1ZZmZCvrEII0YO4mp8sDLXC8g1aUAoi8TJgxq2MJqCaMyj5kAm3Fdy2tzftPCV/lbdiJqmBnWKjtwIDA" }]
    }, {
    name   = "api"
    type   = "A"
    values = [{ value = "201.20.14.62" }]
    }, {
    name   = "mail"
    type   = "A"
    values = [{ value = "13.68.91.91" }]
    }, {
    name   = "mailgun"  
    type   = "TXT"
    values = [{ value = "\"v=spf1 include:mailgun.org ~all\"" }]
    }, {
    name   = "mailo._domainkey.mailgun"
    type   = "TXT"
    values = [{ value = "k=rsa;" }]
    }, {
    name   = "sandbox"
    type   = "A"
    values = [{ value = "201.20.14.62" }]
    }, {
    name   = "sbx"
    type   = "A"
    values = [{ value = "201.20.14.77" }]
    }, {
    name   = "tracking"
    type   = "CNAME"
    values = [{ value = "api.elasticemail.com" }]
    }, {
    name   = "traffic"
    type   = "A"
    values = [{ value = "201.20.14.62" }]
    }, {
    name   = "www"
    type   = "A"
    values = [{ value = "54.233.223.141" }]
    }, {
    name   = "zb14877009"
    type   = "CNAME"
    values = [{ value = "zmverify.zoho.com" }]
    }, {
    name   = "portal"
    type   = "CNAME"
    values = [{ value = "api-portal.t0.production.us-east-1.aws.sensedia.net" }]
  }]

  depends_on = [
    azurerm_dns_zone.dns_zone,
    google_dns_managed_zone.dns_zone,
  ]
}