locals {
  bcg_org_name      = lower(var.bcg_org_name)
  env               = lower(var.env)
  product_name      = lower(var.product_name)
  region            = lower(var.region)
  db_name           = lower(var.db_name)
  sb_name           = lower(var.sb_name)
  vm_name           = lower(var.vm_name)
  vm_startup_script = replace("${local.vm_name}.sh", "-", "_")
  vm_target_tags    = ["test"]
}