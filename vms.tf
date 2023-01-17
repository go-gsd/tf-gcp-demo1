resource "google_service_account" "instance_sa" {
  project      = module.test_project.project_id
  account_id   = "svc-${local.vm_name}-${random_id.suffix.hex}"
  display_name = "Virtual Machine service account"
}

data "google_compute_zones" "available" {
  project = module.test_project.project_id
  region  = local.region
  status  = "UP"
}

resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.available.names
  result_count = 1
}

resource "google_compute_instance" "dev_instance" {
  name                      = "vm-gcp-${local.bcg_org_name}-${local.product_name}-${local.env}-${local.vm_name}-${random_id.suffix.hex}"
  project                   = module.test_project.project_id
  zone                      = random_shuffle.zone.result[0]
  machine_type              = "e2-custom-2-9728"
  tags                      = local.vm_target_tags
  allow_stopping_for_update = true
  metadata_startup_script   = file("${path.module}/scripts/${local.vm_startup_script}")

  network_interface {
    subnetwork = module.test_vpc.subnets_self_links[0]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
      size  = 10
    }
  }

  service_account {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
