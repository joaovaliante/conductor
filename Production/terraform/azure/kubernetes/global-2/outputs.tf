output "ingress_ip" {
  value = azurerm_public_ip.nginx_ingress.ip_address
}

output "ingress_pier_ip" {
  value = azurerm_public_ip.nginx_ingress_pier.ip_address
}