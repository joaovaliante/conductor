env=qa;
terraform apply -var-file=config/${env}.tfvars $@
# $@ -> all of the parameters passed to the script: p1, p2, p3 ...
# ./script.sh p1 p2 