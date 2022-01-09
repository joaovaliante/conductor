output "application_gateway_public_ip" {
  value = module.application-gateway-ip.ip
}

output "apim_management_public_ip" {
  value = module.apim-management-public-ip.ip
}