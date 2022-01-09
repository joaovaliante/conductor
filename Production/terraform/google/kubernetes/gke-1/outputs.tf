output "ingress_ip" {
  value = module.ingress_static_ip.address
}

output "ingress_pier_ip" {
  value = module.ingress_pier_static_ip.address
}