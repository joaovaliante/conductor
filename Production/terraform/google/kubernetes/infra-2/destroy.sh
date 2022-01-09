env=prd;
terraform destroy -var-file=config/${env}.tfvars $@