###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}


variable "os_image" {
  type    = string
  default = "ubuntu-2004-lts"
}

# variable for count-vm
variable "yandex_compute_instance_develop" {
  type        = list(object({
    vm_name = string
    cores = number
    memory = number
    core_fraction = number
    count_vms = number
    platform_id = string
  }))

  default = [{
      vm_name = "web"
      cores         = 2
      memory        = 1
      core_fraction = 5
      count_vms = 2
      platform_id = "standard-v1"
    }]
}


# variable for disk_vm 
variable "storage_disk" {
  type = list(object({
    for_storage = object({
      size       = number
      count      = number
      name = string
    })
  }))

  default = [
    {
      for_storage = {
        size       = 1
        count      = 3
        name = "disk"
      }
    }
  ]
}

variable "yandex_compute_instance_storage" {
  type = object({
    storage_resources = object({
      cores        = number
      memory       = number
      core_fraction = number
      name         = string
      count        = number
      platform_id = string
    })
  })

  default = {
    storage_resources = {
      cores        = 2
      memory       = 1
      core_fraction = 5
      name         = "storage"
      count      = 1
      platform_id = "standard-v1"
    }
  }
}

variable "each_vm" {
  type = list(object({  cpu=number, ram=number, disk=number, core_fraction=number }))
  default = [
    {  cpu=4, ram=2, disk=10, core_fraction = 5 },
    {  cpu=2, ram=1, disk=15, core_fraction = 5 }
  ]
}

variable "vm_names" {
  type    = list(string)
  default = ["main", "replica"]
}

variable "vm_for_each_platform" {
  type = string
  default = "standard-v1"
}

variable "vm_for_each_type" {
  type = string
  default = "network-hdd"
}