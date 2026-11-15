terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.120"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.6.0"
    }
  }

  required_version = ">= 1.5"
}

provider "yandex" {
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.zone
}