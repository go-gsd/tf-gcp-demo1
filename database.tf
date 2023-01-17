resource "google_project_service" "service_networking_api" {
  project            = module.test_project.project_id
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "sql_admin_api" {
  project            = module.test_project.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = true
}

resource "google_compute_global_address" "private_ip_address" {
  project = module.test_project.project_id
  network = module.test_vpc.network_self_link
  #network       = "projects/${var.host_project_id}/global/networks/${var.network}"
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  depends_on    = [google_project_service.service_networking_api, google_project_service.sql_admin_api]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.test_vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_password" "root_password" {
  length = 10
}

resource "google_sql_database_instance" "postgres_instance" {
  project          = module.test_project.project_id
  name             = local.db_name
  region           = local.region
  database_version = "POSTGRES_14"
  root_password    = random_password.root_password.result
  # whether or not to allow Terraform to destroy the instance
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = module.test_vpc.network_self_link
    }
  }
  depends_on = [google_service_networking_connection.private_vpc_connection]
}

/*
resource "google_project_iam_member" "sql_admins" {
  project    = var.project_id
  role       = "roles/cloudsql.admin"
  for_each   = toset(var.admins)
  member     = "user:${each.key}"
}
*/