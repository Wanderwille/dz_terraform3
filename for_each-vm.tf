resource "yandex_compute_instance" "for_each" {
  
  for_each = zipmap(var.vm_names, var.each_vm)
  name        = "${each.key}"
  platform_id = var.vm_for_each_platform
  resources {
    cores         = "${each.value.cpu}"
    memory        = "${each.value.ram}"
    core_fraction = "${each.value.core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vm_for_each_type
      size = "${each.value.disk}"
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