output "function_service_account" {
  value = google_cloudfunctions_function.function.service_account_email
}

output "source_bucket_url" {
  value = google_storage_bucket.source_bucket.url
}

output "function_environment_variables" {
  value = google_cloudfunctions_function.function.environment_variables
}
