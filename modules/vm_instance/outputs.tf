output "ip" {
  
  value = libvirt_domain.vm_instance.network_interface.0.addresses.0

}
