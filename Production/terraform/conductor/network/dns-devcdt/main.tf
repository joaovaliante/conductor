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
    name = "@"
    type = "MX"
    values = [ 
       { preference = "20"
        value = "mxb.mailgun.org" }, 
       { preference = "10"  
        value = "mxa.mailgun.org" }] 
    }, {
    name   = "@"
    type   = "TXT"
    values = [{ value = "v=spf1 include:spf.mailjet.com -all" }]
    }, {
    name   = "mailjet._43271a35"
    type   = "TXT"
    values = [{ value = "43271a355e4fbe354916f948b77de5a1" }]
    }, {
    name   = "mailjet._domainkey"
    type   = "TXT"
    values = [{ value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDAiXWjk0y5X5xSKmhHiC7uqO/Vss5I4f1LwzSzptZunjM6JO13K+L149xSB+InlSO6AjnpF/SSA7sGEv1jIsh6nMJ/yIEB/CA1DKAzJB1nzqCeMZG35+l87FUZTcQJ4xSuBDO5Um4i9bCrGT8zEYx+iV+qdL7QcbsQhy4BB6rTHwIDAQAB" }]
    }, {
    name   = "pic._domainkey"
    type   = "TXT"
    values = [{ value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDe3IuxkEOWmfJ4HH+X0oTp9ah67F0plrwSjQumRctFGeNdmBdC3QQmJreMpYGwzQj6HHzFhPbCB3sjW+fQewbioIPBWpN7WP2KJIFbU6Z/q7Tna0JTIS8AG3GbSc5qoTc+KV9bcr8PhfC1pyRxSZikFXoCzDO8TRI+8YsXvq3CQwIDAQAB" }]
    }, {
    name   = "s1._domainkey"
    type   = "CNAME"
    values = [{ value = "s1.domainkey.u18676847.wl098.sendgrid.net" }]
    }, {
    name   = "s2._domainkey"
    type   = "CNAME"
    values = [{ value = "s2.domainkey.u18676847.wl098.sendgrid.net" }]
    }, {
    name   = "api-hub-sbx"
    type   = "CNAME"
    values = [{ value = "conductor-api-gtw-dev-scus.azure-api.net" }]
    }, {
    name   = "apim"
    type   = "A"
    values = [{ value = "52.153.115.44" }]
    }, {
    name   = "ben-ec-front-staging"
    type   = "CNAME"
    values = [{ value = "blue-ec-front-staging.azurewebsites.net" }]
    }, {
    name   = "ben-mule-hmlg"
    type   = "A"
    values = [{ value = "40.74.177.221" }]
    }, {
    name   = "ben-rh-front-staging"
    type   = "CNAME"
    values = [{ value = "blue-rh-front-staging.azurewebsites.net" }]
    }, {
    name   = "ben-mule-hmlg.devcdt.com.br"
    type   = "A"
    values = [{ value = "40.74.177.221" }]
    }, {
    name   = "c6bank-gtw-k8s"
    type   = "A"
    values = [{ value = "13.84.222.29" }]
    }, {
    name   = "cielopay-heimdall"
    type   = "A"
    values = [{ value = "191.235.116.247" }]
    }, {
    name   = "conductor"
    type   = "TXT"
    values = [{ value = "v=spf1 include:mailgun.org ~all" }]
    }, {
    name   = "krs._domainkey.conductor"
    type   = "TXT"
    values = [{ value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpfA8oViltv3wErWS1Xq0hLQbj+AHBuRHHjWXF+KSWEg3nbO0kmZQAznxmWr1ABMFOFsFsvmKIajz7BqFI51TjevBuCi/DUruHSwebDHolOx36cPze/UJxveyLYbqolrUpmnwqYAGJvegqSTfe7umyYSKRNbbmFRRT7ueg8J/xxQIDAQAB" }]
    }, {
    name   = "email.conductor"
    type   = "CNAME"
    values = [{ value = "mailgun.org" }]
    }, {
    name   = "crefisa-api-hmlext"
    type   = "A"
    values = [{ value = "13.65.30.229" }]
    }, {
    name   = "em160"
    type   = "CNAME"
    values = [{ value = "u18676847.wl098.sendgrid.net" }]
    }, {
    name   = "gateway-apim"
    type   = "A"
    values = [{ value = "20.201.11.34" }]
    }, {
    name   = "heimdall-ben-develop"
    type   = "A"
    ttl    = "120"
    values = [{ value = "104.215.89.17" }]
    }, {
    name   = "heimdall-ben-qa"
    type   = "A"
    ttl    = "120"
    values = [{ value = "104.215.89.17" }]
    }, {
    name   = "heimdall-ben-staging"
    type   = "A"
    ttl    = "60"
    values = [{ value = "191.235.240.118" }]
    }, {
    name   = "heimdall-ben-staging-v2"
    type   = "A"
    values = [{ value = "191.234.194.147" }]
    }, {
    name   = "heimdall-c6bank-hmle-gcp"
    type   = "A"
    values = [{ value = "34.102.133.151" }]
    }, {
    name   = "heimdall-c6bank-hmlext"
    type   = "A"
    values = [{ value = "65.52.32.220" }]
    }, {
    name   = "heimdall-hmlext"
    type   = "A"
    values = [{ value = "34.120.178.173" }]
    }, {
    name   = "hmlfdpagseguro"
    type   = "CNAME"
    values = [{ value = "pagsegurohmlg.azurefd.net" }]
    }, {
    name   = "jiraia-bot"
    type   = "A"
    values = [{ value = "40.84.133.117" }]
    }, {
    name   = "mail"
    type   = "TXT"
    values = [{ value = "v=spf1 include:mailgun.org ~all" }]
    }, {
    name   = "k1._domainkey.mail"
    type   = "TXT"
    values = [{ value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYSHKnZGJ2thOeL+7zOnfYL0I/NO0EaqlZred65goRgf9pG+Q7wowK4yo0jw1Qaoa1T3uxQat4NVDgc0cyiDkQzuQnmB1GSGPWJ2OHAfkVvkSws5vi/Yt+9kjSwPpLElCvzIY6hvs/8mOc0IHwPtbZS/AzYYTZeMYXkLlDlYULnQIDAQAB" }]
    }, {
    name   = "pier-cdt-gcp-hmlext"
    type   = "A"
    values = [{ value = "34.120.125.117" }]
    }, {
    name   = "pier-cdt-hmlext"
    type   = "A"
    values = [{ value = "34.120.125.117" }]
    }, {
    name   = "pier-gcp-hmlext"
    type   = "A"
    values = [{ value = "34.120.178.173" }]
    }, {
    name   = "pier-hml-arbi"
    type   = "A"
    values = [{ value = "34.120.178.173" }]
    }, {
    name   = "pier-hmlext"
    type   = "A"
    values = [{ value = "34.120.178.173" }]
    }, {
    name   = "pier-hmlg-fortbrasil"
    type   = "A"
    values = [{ value = "104.44.133.152" }]
    }, {
    name   = "pnb-hml-pier"
    type   = "A"
    values = [{ value = "191.232.199.244" }]
    }, {
    name   = "pnb-hmlext-pier"
    type   = "A"
    values = [{ value = "10.60.33.74" }]
    }, {
    name   = "qlik-ben"
    type   = "A"
    values = [{ value = "40.119.2.143" }]
    }, {
    name   = "r2-c6bank-hmlext"
    type   = "A"
    values = [{ value = "13.65.96.201" }]
    }, {
    name   = "r2-c6bank-iris"
    type   = "A"
    values = [{ value = "13.65.96.201" }]
    }, {
    name   = "rancher"
    type   = "A"
    values = [{ value = "10.75.212.5" }]
    }, {
    name   = "rancher-ben"
    type   = "A"
    values = [{ value = "10.70.33.21" }]
    }, {
    name   = "rancher-gcp"
    type   = "A"
    values = [{ value = "34.107.192.196" }]
    }, {
    name   = "rancher-gcp-hml"
    type   = "A"
    values = [{ value = "10.75.130.4" }]
    }, {
    name   = "rancher2-hmlg"
    type   = "A"
    values = [{ value = "10.70.30.7" }]
    }, {
    name   = "renner-hmlext-gateway"
    type   = "A"
    values = [{ value = "40.84.151.121" }]
    }, {
    name   = "rh-stress-heimdall"
    type   = "A"
    values = [{ value = "20.195.163.102" }]
    }, {
    name   = "rk8s"
    type   = "A"
    values = [{ value = "13.66.32.141" }]
    }, {
    name   = "rundeck-auth"
    type   = "A"
    ttl    = "120"
    values = [{ value = "10.75.220.18" }]
    }, {
    name   = "sandbox-dock"
    type   = "CNAME"
    values = [{ value = "sandbox-cdt.azurefd.net" }]
    }, {
    name   = "test-token-dev"
    type   = "CNAME"
    values = [{ value = "cdttokenizationapi-dev.azurewebsites.net" }]
    }, {
    name   = "teste-api"
    type   = "CNAME"
    values = [{ value = "lab-api-management-to-mig-prod.azure-api.net" }]
    }, {
    name   = "teste-api-management-1"
    type   = "CNAME"
    values = [{ value = "lab-api-management-to-mig-prod.azure-api.net" }]
    }, {
    name   = "teste-api-management-2"
    type   = "CNAME"
    values = [{ value = "lab-api-management-to-mig-prod.azure-api.net" }]
    }, {
    name   = "visadirect-hmlg"
    type   = "CNAME"
    values = [{ value = "gtwhmlcdt.azurefd.net" }]
    }, {
    name = "vnext"
    type = "NS"
    values = [
      { value = "ns1-01.azure-dns.com" },
      { value = "ns2-01.azure-dns.net" },
      { value = "ns3-01.azure-dns.org" },
    { value = "ns4-01.azure-dns.info" }]
  }]

  depends_on = [
    azurerm_dns_zone.dns_zone,
    google_dns_managed_zone.dns_zone,
  ]
}