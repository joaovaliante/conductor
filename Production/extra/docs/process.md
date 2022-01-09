# Processo

## [Diagrama](https://lucid.app/lucidchart/invitations/accept/0abea652-8e73-4ea9-a818-7583e460f4fd)

![image.png](/.attachments/image-d1bb275c-3174-4880-ab25-14396197c232.png)


## Detalhamento

O diagrama acima mostra o esboço do modelo criado para os sistemas (Cipher, Pier & Heimdall)

### 1 - [Terraform Modules](https://conductortech.visualstudio.com/Terraform%20Modules)
São módulos genéricos de terraform para padronizar, facilitar e encapsular determinadas necessidades. 

_Exemplo:_

Foi criado um módulo chamado cdt-cluster (Azure e Google), na qual ele já faz a criação do Cluster de Kubernetes baseado nos padrões da Conductor e aplica funcionalidades básicas como Rancher (Gerenciamento) e Monitoramento com alertas.

### 2 - [Helm Applications](https://conductortech.visualstudio.com/Helm%20Application)
Definição das aplicações utilizando o Helm para instalação / atualização de novas versões das aplicações. Utilizando o Helm é possível aplicar as melhoras práticas de definição de aplicação no Kubernetes (PodAntiAffinity, Resources, etc)

### 3 - [Container IaC](/patterns#docker)
No pipeline de IaC foi utilizando uma Image do Docker como base, com as principais ferramentas. O pipeline utilizará essa imagem como _"Host"_ para executar as funções do pipeline. (Terraform, Ansible, Git, etc)

**_Não deverá ser instalado ferramentas no agente de CI/CD_**

### 4 - [Configuration / Variables](/index#configurações)
As configurações do ambiente e variáveis são utilizadas para sobrescrever informações em arquivos `yaml` e `variables.tf`

### 5 - Execution Plan
Após todas as configurações aplicadas, é executado o comando `terraform plan` para que seja gerado o plano de alterações a serem aplicadas do ambiente, podem ser criação de novos recursos, alteração de recursos já existentes e exclusão de recursos existentes.

### 6 - Storage Execution Plan
Após a geração do _Execution Plan_ o mesmo é persistido como artefato do estágio, esse plano contem todas as alterações a serem feitas no ambiente. Esse _Execution Plan_ será utilizado no futuro para aplicar essas alterações.

### 7 - [Approvals](/index#aprovações)
As aprovações são utlizadas como _Gates_ para que o responsável possa analisar o _Execution Plan_ e verificar se as alterações a serem aplicadas estão corretas. Nesse caso ele pode aprovar ou recusar o _Execution Plan_ e com isso podendo continuar as alterações ou parar o processo.

### 8 - Load Execution Plan
É baixado o _Execution Plan_ aprovado dos artefatos e deixa disponível para ser aplicado.

### 9 - Apply Plan
É aplicado o _Execution Plan_ aprovado, somente as alterações descritas no _Execution Plan_ serão aplicadas.


