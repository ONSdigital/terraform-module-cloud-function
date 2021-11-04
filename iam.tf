resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.trigger_http ? google_cloudfunctions_function.http-function[0].project : google_cloudfunctions_function.function[0].project
  region         = var.trigger_http ? google_cloudfunctions_function.http-function[0].region : google_cloudfunctions_function.function[0].region
  cloud_function = var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name

  role   = "roles/cloudfunctions.invoker"
  member = length(var.service_account_email) > 0 ? "serviceAccount:${var.service_account_email}" : "serviceAccount:${local.default_service_account_email}"
}
