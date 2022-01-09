# Boas Práticas & Patterns

## Docker

O Docker é uma grande ferramenta, tanto para fazer build de uma aplicação quanto rodar uma determinada aplicação.

No nosso caso estamos usando o agente de DevOps utilizando uma image como base `desenvolvimento.azurecr.io/cdt-iac:latest`, nessa imagem já foi feito a instalação / preparação de todas as ferramentas básicas. 

Foi criado um [repositório](https://conductortech.visualstudio.com/Conductor%20IaC/_git/docker) Git e Pipeline na qual automáticamente faz publicação da nova versão da imagem.

> Não devemos instalar nenhuma ferramenta no agente de CI/CD (Azure DevOps, Jenkins, Gitlab CI, etc), devemos sempre usar como base uma imagem de _**Docker**_

Hoje no repositório temos 2 imagens:

### desenvolvimento.azurecr.io/cdt-iac:latest
Temos os seguintes pacotes instalados:
- curl
- tar
- wget
- python3
- ansible
- terraform
- kubectl
- ranchercli
- helm

### desenvolvimento.azurecr.io/cdt-iac-google:latest
Essa imagem tem como herança a imagem `desenvolvimento.azurecr.io/cdt-iac:latest` e faz a instalação das seguintes pacotes:
- gcloud-sdk

## Terraform
### Modules
Sempre que possível criar novos módulos que podem ser fácilmente reutilizados, utilizando o conceito de encapsulamento e herança de funcionalidade / comportamento

### Terraform State
Sempre devemos utilizar o backend do terraform como um Storage Externo (S3, Google Storage, Azure Blob Storage), utilizando essas ferramentas o _State_ da sua infraestrutura é sempre persistido em Storage Externo, na qual com isso é feito _**Lock**_ de utilização.


### Terraform dividindo para ganhar
Importante sempre dividir o _terraform_ pelo menos em 2 módulos. Ex: Infraestructure, Application

Pois as vezes mudanças manuais feitas diretamente na aplicação, podem impactar diretamente na evolução da sua infraestrutura básica e da mesma forma para aplicação