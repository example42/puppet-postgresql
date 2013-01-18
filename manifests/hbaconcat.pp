class postgresql::hbaconcat {

  include concat::setup
  include postgresql

  concat { "${postgresql::config_file_hba}":
    mode    => '0600',
    owner   => $postgresql::config_file_owner,
    group   => $postgresql::config_file_group,
    require => Package['postgresql'],
  }

  # The File Header. With Puppet comment
  concat::fragment { 'postgresql_hba_header':
    target  => $postgresql::config_file_hba,
    content => template('postgresql/concat_hba_header.erb'),
    order   => '01',
    notify  => Service['postgresql'],
  }

  # The File Footer. With default acls
  concat::fragment { 'postgresql_hba_footer':
    target  => $postgresql::config_file_hba,
    content => template('postgresql/concat_hba_footer.erb'),
    order   => '90',
    notify  => Service['postgresql'],
  }

}
