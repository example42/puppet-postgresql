#
# = Class: postgresql::install
#
# This class installs postgresql using available system packages
#
class postgresql::install {

  if $postgresql::package_name {
    package { $postgresql::package_name:
      ensure   => $postgresql::package_ensure,
      name     => $postgresql::package_name,
      alias    => '$postgresql',
    }
  }

}
