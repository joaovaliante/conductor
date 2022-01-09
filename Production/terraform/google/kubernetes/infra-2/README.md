###  Exemplos de uso terraform 

Antes de se utilizar os comandos terraform recomenda-se configurar a variável de ambiente **env**.

```
env=prd
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars
```

