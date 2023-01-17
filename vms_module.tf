/*
module "dqc_vm1_sandbox" {
  source = "app.terraform.io/GammaTFCloud/bcgx-vm/google"
  env    = "sandbox"
  region = "us-central1"
  #host_project_id = data.terraform_remote_state.networking.outputs.host_project_id_nonprod
  host_project_id = data.terraform_remote_state.networking.outputs.host_project_id_nonprod
  product_name    = "dp"
  project_id      = data.terraform_remote_state.baseline.outputs.project_id
  shared_vpc_name = data.terraform_remote_state.networking.outputs.vpc_name_nonprod
  vm_name         = "vm1"
  os              = "ubuntu-2204"
  machine_type    = "e2-standard-4"
  enable_ext_ip   = true
  source_ranges   = ["210.57.46.70", "210.57.46.71", "210.57.46.72", "159.135.134.73", "159.135.134.74", "159.135.134.113", "159.135.134.114", "159.135.134.30", "159.135.134.31", "159.135.134.32", "159.135.134.103", "159.135.134.104", "159.135.134.77", "159.135.134.78", "161.47.201.135", "161.47.201.136", "161.47.201.137", "161.47.201.138", "161.47.201.139"]
  allowed_ports   = ["22"]
  admins          = ["Erdreich.David@bcg.com", "devos.robin@bcg.com", "gijsbers.willem@bcg.com"]
  vm_sa_roles     = ["roles/storage.objectAdmin", "roles/cloudsql.admin"]
}

output "vm_name" {
  value = module.dqc_vm1_sandbox.vm_name
}
*/