env=hml;
terraform destroy -var-file=config/${env}.tfvars $@