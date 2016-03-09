# Class: postgresql::hbaconcat
#
class postgresql::hbaconcat {

  include postgresql

  concat { $postgresql::real_config_file_hba:
    mode    => '0600',
    owner   => $postgresql::config_file_owner,
    group   => $postgresql::config_file_group,
    require => Package['postgresql'],
  }

  # The File Header. With Puppet comment
  concat::fragment { 'postgresql_hba_header':
    target  => $postgresql::real_config_file_hba,
    content => template($postgresql::template_hba_header),
    order   => '01',
    notify  => $postgresql::manage_service_autorestart,
  }

  # The File Footer. With default acls
  concat::fragment { 'postgresql_hba_footer':
    target  => $postgresql::real_config_file_hba,
    content => template($postgresql::template_hba_footer),
    order   => '90',
    notify  => $postgresql::manage_service_autorestart,
  }

}
