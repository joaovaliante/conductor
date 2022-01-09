env=homolog-interno;
terraform destroy -var-file=config/${env}.tfvars $@