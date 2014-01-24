# This define APPENDS a line entry to the pg_ident.conf file
define postgresql::ident ($map_name, $system_user, $db_user, $ensure = 'present', $order = '50',) {
  include concat::setup
  include postgresql::identconcat

  concat::fragment { "ident_fragment_${name}":
    target  => $postgresql::real_config_file_ident,
    content => "${map_name}	${system_user} ${db_user}\n",
    order   => $order,
    ensure  => $ensure,
    notify  => Service['postgresql'],
  }
}

