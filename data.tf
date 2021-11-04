data "google_project" "project" {}

data "archive_file" "source_archive" {
  source_dir  = var.source_directory
  output_path = "./${var.name}.zip"
  type        = "zip"


  excludes = [
    "venv",
    "node_modules",
    "main.zip",
    ".python-version",
    ".terraform-version",
    ".terraform.lock.hcl",
    ".terraform",
    ".cache",
    ".git",
    ".gitignore",
    ".github"
  ]
}
