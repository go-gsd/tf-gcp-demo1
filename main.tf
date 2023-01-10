locals {
  bcg_org_name   = lower(var.bcg_org_name)
  env            = lower(var.env)
  product_name   = lower(var.product_name)
  region         = lower(var.region)
  sb_name        = "data-storage"
  vm_name        = "dev-server"
  vm_target_tags = ["test"]
}

resource "random_id" "suffix" {
  byte_length = 2
}

module "test_project" {
  source                     = "terraform-google-modules/project-factory/google"
  version                    = "14.1.0"
  name                       = "gcp-${local.bcg_org_name}-${local.product_name}-${local.env}"
  random_project_id          = true
  folder_id                  = var.folder_id
  org_id                     = var.org_id
  billing_account            = var.billing_account
  labels                     = var.required_labels
  auto_create_network        = false
  disable_dependent_services = true
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "networkmanagement.googleapis.com"
  ]
}

resource "google_project_iam_member" "project_owners" {
  project  = module.test_project.project_id
  for_each = toset(var.owners)
  role     = "roles/owner"
  member   = "user:${each.key}"
}

/*
module "dqc_storage_sandbox" {
  source       = "app.terraform.io/GammaTFCloud/bcgx-storage-bucket/google"
  env          = "sandbox"
  region       = "us-central1"
  product_name = "dqc"
  project_id   = data.terraform_remote_state.baseline.outputs.project_id
  name         = "dp-bucket"
  iam_members  = [
    {
      role   = "roles/storage.objectAdmin"
      member = "user:Erdreich.David@bcg.com"
    },
    {
      role   = "roles/storage.objectViewer"
      member = "user:Gijsbers.Willem@bcg.com"
    },
  ]
}

output "bucket_name" {
  value = module.dqc_storage_sandbox.name
}


module "dqc_dataproc_sandbox" {
  source              = "app.terraform.io/GammaTFCloud/bcgx-dataproc/google"
  env                 = "sandbox"
  region              = "us-central1"
  host_project_id     = data.terraform_remote_state.networking.outputs.host_project_id_nonprod
  product_name        = "dqc"
  project_id          = data.terraform_remote_state.baseline.outputs.project_id
  shared_vpc_name     = data.terraform_remote_state.networking.outputs.vpc_name_nonprod
  master_nodes        = 1
  worker_nodes        = 3
  admins              = [ "Erdreich.David@bcg.com", "devos.robin@bcg.com", "gijsbers.willem@bcg.com"]
  enable_external_ip  = true
  source_ranges       = [ "210.57.46.70", "210.57.46.71", "210.57.46.72","159.135.134.73", "159.135.134.74","159.135.134.113", "159.135.134.114", "159.135.134.30", "159.135.134.31", "159.135.134.32","159.135.134.103", "159.135.134.104","159.135.134.77", "159.135.134.78","161.47.201.135", "161.47.201.136", "161.47.201.137", "161.47.201.138", "161.47.201.139"]
  optional_components = ["JUPYTER"]
}

module "dqc_sql_sandbox" {
  source              = "app.terraform.io/GammaTFCloud/bcgx-sql-svpc/google"
  version             = "0.0.8"
  host_project_id     = data.terraform_remote_state.networking.outputs.host_project_id_nonprod
  project_id          = data.terraform_remote_state.baseline.outputs.project_id
  network             = data.terraform_remote_state.networking.outputs.vpc_name_nonprod
  region              = "us-central1"
  product_name        = "dqc"
  env                 = "sandbox"
  db_engine           = "SQLSERVER_2017_STANDARD"
  instance_size       = "db-custom-2-4096"
}

output "sql_password" {
  value = module.dqc_sql_sandbox.root_password
  sensitive = true
}

data "terraform_remote_state" "baseline" {
  backend = "remote"
  config = {
    organization = "GammaTFCloud"
    workspaces = {
      name = "baseline-gcp-gp-dqc-sandbox"
    }
  }
}

data "terraform_remote_state" "networking" {
   backend = "remote"
   config = {
    organization = "GammaTFCloud"
     workspaces = {
       name = "platform-gcp-gp-networking-nonprod"
     }
   }
}
*/