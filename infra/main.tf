data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "net" {
  name = "${var.vm_name}-net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.vm_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_vpc_security_group" "sg" {
  name        = "${var.vm_name}-sg"
  network_id  = yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  hostname    = var.vm_name
  zone        = var.zone
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 50
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      users:
        - name: ${var.ssh_user}
          groups: sudo
          shell: /bin/bash
          sudo: ALL=(ALL) NOPASSWD:ALL
          ssh_authorized_keys:
            - ${file(pathexpand(var.ssh_public_key_path))}
      runcmd:
        - curl -fsSL https://get.docker.com | sh
        - usermod -aG docker ${var.ssh_user}
    EOF
  }
}
