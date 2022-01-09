env=hmlg;
terraform destroy -var-file=config/${env}.tfvars $@