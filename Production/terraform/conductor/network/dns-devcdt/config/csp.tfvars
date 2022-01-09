subscription        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
resource_group_name = "network"
project             = "cdt-infra-tools-prd"

dns_name             = "devcdt.com.br"
dns_zone_name        = "devcdt-public-zone"
dns_zone_description = "devcdt Public DNS Zone"
tags = {
  "Centro_Custo" = "Cloud"
  "Processing"   = "Issuer"
  "Ambiente"     = "Producao"
  "Produto"      = "Cloud Network"
  "Application"  = "DNS"
}