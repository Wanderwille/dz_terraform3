resource "yandex_compute_disk" "disk_vm" {
  count = var.storage_disk[0].for_storage.count
  name = "${var.storage_disk[0].for_storage.name}-${count.index+1}"
  size = var.storage_disk[0].for_storage.size
}

resource "yandex_compute_instance" "storage" {
  count = var.yandex_compute_instance_storage.storage_resources.count
  name        = "${var.yandex_compute_instance_storage.storage_resources.name}-${count.index+1}"
  depends_on = [yandex_compute_disk.disk_vm]
  platform_id = var.yandex_compute_instance_storage.storage_resources.platform_id
  
  
  resources {
    cores         = var.yandex_compute_instance_storage.storage_resources.cores
    memory        = var.yandex_compute_instance_storage.storage_resources.memory
    core_fraction = var.yandex_compute_instance_storage.storage_resources.core_fraction
  }
  
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }


dynamic "secondary_disk" {
  for_each = yandex_compute_disk.disk_vm[*].id
  content {
    disk_id = secondary_disk.value
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