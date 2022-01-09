output "ingress_public_ip" {
  value = module.ingress_static_public_ip.address
}

output "ingress_private_ip" {
  value = module.ingress_static_private_ip.address
}