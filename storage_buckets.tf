resource "google_storage_bucket" "data_storage" {
  name                        = "sb-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}-${local.sb_name}-${random_id.suffix.hex}"
  project                     = module.test_project.project_id
  location                    = local.region
  storage_class               = "STANDARD"
  labels                      = var.required_labels
  uniform_bucket_level_access = true
  force_destroy               = true

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "storage_bucket_owners" {
  bucket   = google_storage_bucket.data_storage.name
  for_each = toset(var.owners)
  role     = "roles/storage.objectViewer"
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
*/