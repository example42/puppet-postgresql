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
  concat::fragment { 'postgresqt_hba_header':
    target  => $postgresql::config_file_hba,
    content => "# File Managed by Puppet\n",
    order   => '01',
    notify  => Service['postgresql'],
  }

  # The File Footer. With default acls
  concat::fragment{ 'postgresqt_hba_footer':
    target  => $postgresql::config_file_hba,
    content => template('postgresql/concat_hba_footer.erb'),
    order   => '90',
    notify  => Service['postgresql'],
  }

}
