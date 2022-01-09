env=csp;
terraform destroy -var-file=config/${env}.tfvars $@