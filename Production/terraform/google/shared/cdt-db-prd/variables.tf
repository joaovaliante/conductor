# variaveis comuns
variable "project" {
  type        = string
  description = "ID do projeto na Google Cloud."
}
variable "region" {
  type        = string
  description = "Regiao principal a ser utilizada na Google Cloud."
}
variable "zone" {
  type        = string
  description = "Zona a ser utilizada na Google Cloud."
  default     = "us-east4-a"
}
variable "env_name" {
  type        = string
  default     = "prd"
  description = "Prefixo utilizado para nomear recursos."
}