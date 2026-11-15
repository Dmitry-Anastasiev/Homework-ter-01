variable "YC_CLOUD_ID" {
  type        = string
}

variable "YC_FOLDER_ID" {
  type        = string
}

variable "vm_name" {
  type    = string
  default = "lab-vm"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}