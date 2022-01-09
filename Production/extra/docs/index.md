# Conductor IaC

O Infraestructure As Code (IaC) da Conductor utiliza como base o Terraform.

## Azure DevOps
### Templates
A pasta `templates` contem os Azure DevOps Templates o principal arquivo é o `terraform.yaml` na qual faz a definição das ações **Plan** e **Apply**

#### Plan
- Inicialização do Usuário de Serviço para baixar os módulos da Conductor
- Substituição das variáveis para Helm (yaml)
- Substituição das variáveis para Terraform (variables.tf)
- Criação do Plano de Execução
- Salvar como Artefato o Plano de Execução

#### Apply
- Inicialização do Usuário de Serviço para baixar os módulos da Conductor
- Baixar o Plano de Execução
- Aplicar o Plano de Execução

O template `app-pipeline.yaml` encapsula a criação e instalação dos sistemas **Pier** e **Heimdall** utilizando o template `terraform.yaml`.

### Aprovações
Foi criado um ambiente (Environment) no Azure DevOps chamado `Production` na qual foi definido uma aprovação obrigatória, com isso, após a execução do _Plano de Execução_ é necessário aprovação para que seja aplicado o _Plano de Execução_

![image.png](/.attachments/image-7da72135-28cf-4ff1-99eb-5da34904ae07.png)

![image.png](/.attachments/image-888dcd18-1135-41eb-85fa-64627d32fc61.png)

### Configurações
É utilizado o _Variable Groups_ para provisionar informações de específicas de cada ambiente

![image.png](/.attachments/image-fe7c41a5-045d-40ff-a3fa-61447fcc4923.png)

As configurações porem ser aplicadas em camadas, com isso por exemplo podemos utlizar a configuração `kubernetes-base` e `kubernetes-google` para ambientes Google e por exemplo `kubernetes-base` e `kubernetes-azure` para ambientes com Azure. Os 2 ambientes vão utilizar o grupo de variáveis `kuberentes-base`.

![image.png](/.attachments/image-340e3e82-4991-45f5-9fe9-8aecdebcaf3f.png)
**Essas variáveis serão substituídas no processo de geração do _Plano de Execução_**

## Terraform
A estrutura da infraestrutura esta divida em 2 steps:
- Infrastructure
- Application

### Infrastructure
Nesse modo é criado / atualizado a infraestrutura básica para suportar a aplicação, infraestrutura de baixo nível:

Ex:
- Criação de Cluster de Kubernetes
- Monitoramento
- Criação de VMs
- Criação de Load Balance
- Criação de IP estático
- Etc

### Application
Nesse modo é criado / atualizado a aplicação:
Ex:
- Instalar a aplicação
- Atualizar a aplicação
- Instalar novos sistemas

Com essa separação podemos aplicar um determinado estágio ou todos os estágios

![image.png](/.attachments/image-7cdcd63a-a3ff-4be2-90af-c4daae18cf2f.png)

## [Processo](/process)

## [Patterns](/patterns)


