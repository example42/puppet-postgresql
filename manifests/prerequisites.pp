# Class: postgresql::prerequisites
#
# This class installs postgresql prerequisites
#
# == Variables
#
# Refer to postgresql class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by postgresql if the parameter
# install_prerequisites is set to true
# Note: This class may contain resources available on the
# Example42 modules set
#
class postgresql::prerequisites {

  if $postgresql::bool_use_postgresql_repo {
    case $::operatingsystem {
      redhat,centos,scientific,oraclelinux : {
        case $postgresql::real_version {
          '9.2': { require yum::repo::pgdg92 }
          '9.3': { require yum::repo::pgdg93 }
          default: { }
        }
      }
      ubuntu,debian : {
        require apt::repo::postgresql
      }
      default: { }
    }
  }
}
