terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0.0, < 3.0.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.54.0, < 4.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.54.0, < 4.0.0"
    }
  }
  required_version = "> 0.12.0, < 0.15.0"
}
