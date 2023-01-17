output "network_id" {
  value = module.test_vpc.network_id
}

output "network_name" {
  value = module.test_vpc.network_name
}

output "network_self_link" {
  value = module.test_vpc.network_self_link
}

output "project_id" {
  value = module.test_project.project_id
}

output "project_name" {
  value = module.test_project.project_name
}

output "sb_full_name" {
  value = google_storage_bucket.data_storage.name
}

output "vm_full_name" {
  value = google_compute_instance.dev_instance.name
}