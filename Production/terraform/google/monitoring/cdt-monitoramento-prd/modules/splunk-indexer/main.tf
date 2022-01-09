locals {
  defaultDisks = [
    {
      device_name : "splunk-data"
      disk_type : var.disk_type_install
      disk_size_gb : var.disk_size_install
    },
    {
      device_name : "splunk-hot"
      disk_type : var.disk_type_hot
      disk_size_gb : var.disk_size_hot
    }
  ]

  summaryDisks = concat(local.defaultDisks, (var.disk_size_summary == null ? [] : [
    {
      device_name : "splunk-summary"
      disk_type : var.disk_type_summary
      disk_size_gb : var.disk_size_summary
    }
  ]))

  disks = concat(local.summaryDisks, [
    {
      device_name : "splunk-cold"
      disk_type : var.disk_type_cold
      disk_size_gb : var.disk_size_cold
    }
  ])
}

module "splunk-indexer" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/machine/vm-shared-vpc"

  instance_name        = "gcp1p-splk-idx${var.instance_number}"
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
  tags                 = ["gcpinfra", "infra", "splunk-idx"]
  labels               = var.labels
  image_family         = "splunk"
  image_project        = "cdt-infra-tools-prd"
  ssh_keys             = var.instance_ssh_keys
  additional_disks     = local.disks
}

resource "null_resource" "splunk-indexer-ansible" {
  provisioner "local-exec" {
    command = <<EOT
	  ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SSH_RETRIES=10 ansible-playbook -u admin_prd --private-key ~/.ssh/id_rsa.pub --tags='install' --extra-vars "splunk_type=indexer timezone=${var.timezone}" -i ${module.splunk-indexer.address}, ${path.root}/../../../ansible/splunk/terraform.yaml
    EOT
  }

  depends_on = [
    module.splunk-indexer
  ]
}