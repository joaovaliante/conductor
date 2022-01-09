module "splunk-loadbalance" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-shared-vpc"

  instance_name        = "gcp1p-splk-lb${var.instance_number}"
  machine_type         = var.instance_type
  type_of_disk         = "pd-balanced"
  boot_disk_size       = 20
  project              = var.project
  region               = var.region
  zone                 = var.zone
  host_vpc_name        = var.host_vpc_name
  host_subnet_name     = var.host_subnet_name
  host_network_project = var.host_network_project
  internal_ip          = var.instance_internal_ip
  tags                 = ["gcpinfra", "infra", "splunk-lb"]
  labels               = var.labels
  ssh_keys             = var.instance_ssh_keys
}

resource "null_resource" "splunk-lb-ansible" {
  provisioner "local-exec" {
    command = <<EOT
	  ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_RETRIES=10 ansible-playbook -u admin_prd --private-key ~/.ssh/id_rsa.pub --extra-vars "certificate_file_path='${var.certificate_file_path}' certificate_key_path='${var.certificate_key_path}' proxy_pass_url='${var.loadbalance_ip}' proxy_pass_port='${var.loadbalance_port}'" -i ${module.splunk-loadbalance.address}, --tags='install,configure' ${path.root}/../../../ansible/splunk/loadbalance.yaml
    EOT
  }

  depends_on = [
    module.splunk-loadbalance
  ]
}