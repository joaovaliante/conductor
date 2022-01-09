output "ingress_ip" {
  value = azurerm_public_ip.nginx_ingress.ip_address
}

output "ingress_pier_ip" {
  value = azurerm_public_ip.nginx_ingress_pier.ip_address
}

# output "rancher_init_url" {
#   value = module.kubernetes.rancher_init_url
# }

# output "odin_primary_ip" {
#   value = module.odin_primary_static_ip.address
# }

# output "odin_secondary_ip" {
#   value = module.odin_secondary_static_ip.address
# }