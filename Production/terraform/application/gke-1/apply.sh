env=prd;
terraform apply -var-file=config/${env}.tfvars $@