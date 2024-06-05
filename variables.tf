variable "base_os_image" {

  description = "(optional) describe your variable"
  #description = "Name for the new base OS image"
  #description   =   "Path of the OS image you want to use"
  type        = object(
    {
      name      = optional( string , "Debian12GenericCloud" )
      path      = optional( string , "/home/diego/Downloads/debian-12-genericcloud-amd64.qcow2" )
      pool_name = optional( string , "base-images" )
    }
  )
  default     = { name      = "Debian12GenericCloud"
                  path      = "/home/diego/Downloads/debian-12-genericcloud-amd64.qcow2"
                  pool_name = "base-images"
                }

}

variable "vms" {
  
  /*
  type = map(
    object(
      {
        vcpu = optional( number , 1 ) ,
        memory  = optional( number , 512 ) ,
      }
    )
  )
  */

}
