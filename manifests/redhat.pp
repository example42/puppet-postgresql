# Define: postgresql::redhat
#
class postgresql::redhat {

  exec { 'postgresql_initdb':
    command => $postgresql::real_initdbcommand,
    creates => $postgresql::real_config_file,
    path    => [ '/sbin', '/bin', '/usr/bin', '/usr/sbin' ],
    require => Package['postgresql'],
    before  => [ Service['postgresql'], File['postgresql.conf'] ],
  }

}
