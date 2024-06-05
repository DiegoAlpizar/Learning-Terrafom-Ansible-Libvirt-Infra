provider "libvirt" {
  
  uri   =   "qemu:///system"
  
}


locals {
  
  workspace = "${ terraform.workspace != "default" ?  "-${ terraform.workspace }"  :  "" }"

}


resource "libvirt_volume" "base_os_image" {
  
  name    = "${ var.base_os_image.name }${ local.workspace }_BaseImage-Terraform.qcow2"
  source  = var.base_os_image.path
  pool    = var.base_os_image.pool_name
  #format  = "qcow2"

}


module "vm_instance" {

  source = "./modules/vm_instance"

  base_volume_id  = libvirt_volume.base_os_image.id

  for_each = var.vms
  
  vm_guest_name = "${ each.key }${ local.workspace }"

}


resource "local_file" "inventory_ini" {

  content   = templatefile( "templates/inventory.ini.tf.tpl" , { ips  = module.vm_instance } )
  filename  = "inventory.ini"

  provisioner "local-exec" {
    
    #  echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no  -o UserKnownHostsFile=/dev/null'"  >>  inventory.ini
    command = "ansible-playbook 'playbook copy.yml'"

  }
  
}

output "ips" {

  value = module.vm_instance

}
