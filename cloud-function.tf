locals {
  default_service_account_email = "${data.google_project.project.name}@appspot.gserviceaccount.com"

  default_env_vars = {
    PROJECT = data.google_project.project.name
  }
}

resource "google_cloudfunctions_function" "function" {
  count                 = var.trigger_http ? 0 : 1
  name                  = var.name
  project               = length(var.project) > 0 ? var.project : data.google_project.project.name
  entry_point           = var.entry_point
  runtime               = var.runtime
  timeout               = var.timeout
  available_memory_mb   = var.available_memory
  service_account_email = length(var.service_account_email) > 0 ? var.service_account_email : local.default_service_account_email
  environment_variables = merge(local.default_env_vars, var.environment_variables)
  labels                = var.labels
  region                = var.region
  source_archive_bucket = google_storage_bucket.source_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name

  event_trigger {
    event_type = length(var.trigger_event_type) > 0 ? var.trigger_event_type : "google.storage.object.finalize"
    resource   = length(var.trigger_event_resource) > 0 ? var.trigger_event_resource : google_storage_bucket.source_bucket.id

    failure_policy {
      retry = var.retry_on_failure
    }
  }
}

resource "google_cloudfunctions_function" "function" {
  count                 = var.trigger_http ? 1 : 0
  name                  = var.name
  project               = length(var.project) > 0 ? var.project : data.google_project.project.name
  entry_point           = var.entry_point
  runtime               = var.runtime
  timeout               = var.timeout
  available_memory_mb   = var.available_memory
  service_account_email = length(var.service_account_email) > 0 ? var.service_account_email : local.default_service_account_email
  environment_variables = merge(local.default_env_vars, var.environment_variables)
  labels                = var.labels
  region                = var.region
  source_archive_bucket = google_storage_bucket.source_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name

  trigger_http = var.trigger_http
}
