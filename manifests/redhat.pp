class postgresql::redhat {

  exec { 'postgresql_initdb':
    command => $postgresql::initdbcommand,
    creates => $postgresql::config_file,
    path    => [ '/sbin', '/bin', '/usr/bin', '/usr/sbin' ],
    require => Package['postgresql'],
    before  => Service['postgresql'],
  }

}
