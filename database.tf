
/*
resource "google_project_service" "ntk_service" {
  for_each           = toset([var.host_project_id, var.project_id])
  project            = each.key
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sql_service" {
  for_each           = toset([var.host_project_id, var.project_id])
  project            = each.key
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_global_address" "private_ip_address" {
  depends_on    = [google_project_service.ntk_service, google_project_service.sql_service]
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  project       = var.host_project_id
  prefix_length = 20
  network       = "projects/${var.host_project_id}/global/networks/${var.network}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "projects/${var.host_project_id}/global/networks/${var.network}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_password" "root_pw" {
  length = 10
}
# Create Cloud SQL instance
resource "google_sql_database_instance" "sql_instance" {
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
  deletion_protection = false //set to true if you dont want tf to destroy the db
  region              = var.region
  database_version    = var.db_engine
  project             = var.project_id
  root_password       = random_password.root_pw.result
  settings {
    tier = var.instance_size
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "projects/${var.host_project_id}/global/networks/${var.network}"
    }
  }
}

resource "google_project_iam_member" "sql_admins" {
  project    = var.project_id
  role       = "roles/cloudsql.admin"
  for_each   = toset(var.admins)
  member     = "user:${each.key}"
}
*/