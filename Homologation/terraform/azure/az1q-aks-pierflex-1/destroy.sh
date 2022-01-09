env=qa;
terraform destroy -var-file=config/${env}.tfvars $@