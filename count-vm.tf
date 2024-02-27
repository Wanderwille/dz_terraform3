data "yandex_compute_image" "ubuntu" {
  family = var.os_image
}

resource "yandex_compute_instance" "develop" {
  name = "${var.yandex_compute_instance_develop[0].vm_name}-${count.index+1}"
  platform_id = var.yandex_compute_instance_develop[0].platform_id
  depends_on = [yandex_compute_instance.for_each]
  count = var.yandex_compute_instance_develop[0].count_vms


  resources {
    cores         = var.yandex_compute_instance_develop[0].cores
    memory        = var.yandex_compute_instance_develop[0].memory
    core_fraction = var.yandex_compute_instance_develop[0].core_fraction
  }


boot_disk {
    initialize_params {
        image_id = data.yandex_compute_image.ubuntu.image_id
    }
}

scheduling_policy {
    preemptible = true
}

network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.ssh
  }
}