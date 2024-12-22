module "network" {
  source  = "../../modules/network"
  project = var.gcp_project_id
  region  = var.default_region
  env     = var.env
}
