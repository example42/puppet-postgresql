# This define APPENDS a line entry to the pg_hba.conf file
#
define postgresql::hba (
  $type,
  $database,
  $user,
  $method,
  $ensure = 'present',
  $order  = '50',
  $address = false,
  $option  = '' ) {

  include concat::setup
  include postgresql::hbaconcat

  concat::fragment { "hba_fragment_${name}":
    target  => $postgresql::configfilehba,
    content => $type ? {
      "local" => "${type}	${database}	${user}	${method}	${option}\n",
      default => "${type}	${database}	${user}	${address}	${method}	${option}\n",
    },
    order   => $order,
    ensure  => $ensure,
    notify  => Service['postgresql'],
  }

}

