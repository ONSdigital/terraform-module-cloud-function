resource "google_storage_bucket" "source_bucket" {
  name                        = "source-${var.name}-bucket"
  force_destroy               = true
  location                    = upper(var.region)
  uniform_bucket_level_access = true

  labels = {
    project = data.google_project.project.name,
  }
}

resource "google_storage_bucket_object" "archive" {
  name   = "${lower(replace(base64encode(data.archive_file.source_archive.output_md5), "=", ""))}.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = data.archive_file.source_archive.output_path
}
