output "function_service_account" {
  value = var.trigger_http ? google_cloudfunctions_function.http-function[0].service_account_email : google_cloudfunctions_function.function[0].service_account_email
}

output "source_bucket_url" {
  value = google_storage_bucket.source_bucket.url
}

output "function_environment_variables" {
  value = var.trigger_http ? google_cloudfunctions_function.http-function[0].environment_variables : google_cloudfunctions_function.function[0].environment_variables
}
