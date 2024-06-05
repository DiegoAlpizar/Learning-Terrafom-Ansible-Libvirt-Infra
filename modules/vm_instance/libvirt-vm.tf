terraform {
  
    required_providers {
      
      libvirt   =   { source = "dmacvicar/libvirt" }

    }

}

/*
provider "libvirt" {
  
  uri   =   "qemu:///system"
  
}
*/

locals {
  
  vm_guest_name = "${ var.vm_guest_name }-Terraform"

}


resource "libvirt_pool" "tmp" {
  
  name = local.vm_guest_name
  type = "dir"
  path = "/home/diego/tmp/VM-Images/${ local.vm_guest_name }"

}


resource "libvirt_volume" "disk" {

  name            = "${ local.vm_guest_name }.qcow2"
  pool            = libvirt_pool.tmp.name  
  format          = "qcow2"
  base_volume_id  = var.base_volume_id

}


// Should preffer templatefile() instead of this data resource
data "template_file" "user_data" {
  
  template = file( "${ path.module }/../../cloud_init.cfg" )
  
}


data "template_file" "meta_data" {
  
  template = file( "${ path.module }/../../cloud_metadata.cfg" )

  vars = {

    hostname  = local.vm_guest_name
    
  }

}


resource "libvirt_cloudinit_disk" "commoninit" {

  name      = "commoninit_${ local.vm_guest_name }.iso"
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
  pool      = libvirt_pool.tmp.name

}


resource "libvirt_domain" "vm_instance" {

  name    = local.vm_guest_name
  memory  = var.memory
  vcpu    = var.vcpu

  cpu { mode = "host-passthrough" }

  disk {
    
    volume_id = libvirt_volume.disk.id
    scsi = "true"

  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {

    network_name    = "default"
    wait_for_lease  = true   # wait to get an IP
    # If networkname is host-bridge do not wait for a lease
    #wait_for_lease = var.networkname == "host-bridge" ? false : true
    hostname        = local.vm_guest_name

  }

  console {
    
    type = "pty"
    target_type = "serial"
    target_port = "0"

  }

  graphics {
    
    type = "spice"
    listen_type = "address"
    autoport = true

  }

  provisioner "remote-exec" {
    
    inline = [ "echo Hello World from ${ self.network_interface.0.hostname }" ]

    connection {
      
      type        = "ssh"
      host        = self.network_interface.0.addresses.0
      user        = var.ssh.user_name
      private_key = file( var.ssh.private_key_path )
      timeout     = "1m"

    }

  }

}
