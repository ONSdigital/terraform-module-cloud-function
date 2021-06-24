resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function[0].project
  region         = google_cloudfunctions_function.function[0].region
  cloud_function = google_cloudfunctions_function.function[0].name

  role   = "roles/cloudfunctions.invoker"
  member = length(var.service_account_email) > 0 ? "serviceAccount:${var.service_account_email}" : "serviceAccount:${local.default_service_account_email}"
}
