env=prd;
terraform plan -var-file=config/${env}.tfvars $@