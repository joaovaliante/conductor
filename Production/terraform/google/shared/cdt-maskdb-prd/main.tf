/******************************************
	Recursos básicos
 *****************************************/
module "base-project" {
  source = "gcs::https://www.googleapis.com/storage/v1/cdt-terraform-module/google/project"

  project = var.project
}
