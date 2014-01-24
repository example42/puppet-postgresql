class postgresql::identconcat {

  include concat::setup
  include postgresql

  concat { "${postgresql::real_config_file_ident}":
    mode    => '0600',
    owner   => $postgresql::config_file_owner,
    group   => $postgresql::config_file_group,
    require => Package['postgresql'],
  }

  # The File Header. With Puppet comment
  concat::fragment { 'postgresql_ident_header':
    target  => $postgresql::real_config_file_ident,
    content => template("${postgresql::template_ident_header}"),
    order   => '01',
    notify  => Service['postgresql'],
  }
}
