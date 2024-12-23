terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.45.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.14.1"
    }
  }
}
