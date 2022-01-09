env=prd;
terraform import -var-file=config/${env}.tfvars $@