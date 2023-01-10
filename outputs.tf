output "network_name" {
  value = module.test_vpc.network_name
}

output "network_self_link" {
  value = module.test_vpc.network_self_link
}

output "project_id" {
  value = module.test_project.project_id
}

output "storage_bucket_name" {
  value = google_storage_bucket.data_storage.name
}