variable "project" {
  default = "<YOUR PROJECT>"
}

provider "google" {
  project = var.project
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

provider "google-beta" {
  project = var.project
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

terraform {
  backend "gcs" {
    bucket = "<YOUR STATE BUCKET>"
    prefix = "cf"
  }
}

module "function" {
  source = "../"

  name             = "file-check-kel2"
  source_directory = "./"
}
