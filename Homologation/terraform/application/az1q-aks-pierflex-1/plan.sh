env=qa;
terraform plan -var-file=config/${env}.tfvars $@