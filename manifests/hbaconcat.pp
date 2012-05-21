class postgresql::hbaconcat {

  include concat::setup

  concat { "${postgresql::configfilehba}":
    mode  => '0600',
    owner => $postgresql::config_file_owner,
    group => $postgresql::config_file_group,
  }

  # The File Header. With Puppet comment
  concat::fragment { 'postgresqt_hba_header':
    target  => $postgresql::configfilehba,
    content => "# File Managed by Puppet\n",
    order   => '01',
    notify  => Service['postgresql'],
  }

  # The File Footer. With default acls
  concat::fragment{ 'postgresqt_hba_footer':
    target  => $postgresql::configfilehba,
    content => template('postgresql/concat_hba_footer.erb'),
    order   => '90',
    notify  => Service['postgresql'],
  }

}
