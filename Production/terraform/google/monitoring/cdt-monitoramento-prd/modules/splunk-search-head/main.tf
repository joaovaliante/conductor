module "splunk-search-head" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-shared-vpc"

  instance_name        = "gcp1p-splk-sh${var.instance_number}"
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
  tags                 = ["gcpinfra", "infra", "splunk-sh"]
  labels               = var.labels
  image_family         = "splunk"
  image_project        = "cdt-infra-tools-prd"
  ssh_keys             = var.instance_ssh_keys
  additional_disks = [
    {
      device_name : "splunk-data"
      disk_type : var.disk_type
      disk_size_gb : var.disk_size
    }
  ]
}

resource "null_resource" "splunk-search-head-ansible" {
  provisioner "local-exec" {
    command = <<EOT
	  ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_RETRIES=10 ansible-playbook -u admin_prd --private-key ~/.ssh/id_rsa.pub --tags='install' --extra-vars "splunk_type=search-head timezone=${var.timezone}" -i ${module.splunk-search-head.address}, ${path.root}/../../../ansible/splunk/terraform.yaml
    EOT
  }

  depends_on = [
    module.splunk-search-head
  ]
}