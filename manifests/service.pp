#
# = Class: postgresql::service
#
# This class manages postgresql service
#
class postgresql::service {

  if $postgresql::service_name {
    service { $postgresql::service_name:
      ensure     => $postgresql::manage_service_ensure,
      name       => $postgresql::service_name,
      enable     => $postgresql::manage_service_enable,
      alias      => '$postgresql',
    }
  }
}
