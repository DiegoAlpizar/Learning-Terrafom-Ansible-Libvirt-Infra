variable "base_volume_id" {
  
  description = "Base OS volume resource ID"
  
}

variable "vm_guest_name" {
  
  description = "Guest vm name as seen by the host hypervisor"
  default     = "Debian-Terraform"

}

variable "memory" {

  type        = number
  description = "RAM to alocate for the vm"
  default     = 512

}

variable "vcpu" {

  type        = number
  description = "Cores to alocate for the vm"
  default     = 1

}

variable "ssh" {
  
  default = { user_name         = "ansible"
              private_key_path  = "~/.ssh/id_rsa"
            }

}
