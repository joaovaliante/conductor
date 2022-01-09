env=qa;
terraform apply -var-file=config/${env}.tfvars $@