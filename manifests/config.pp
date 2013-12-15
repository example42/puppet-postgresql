#
# = Class: postgresql::config
#
# This class configures postgresql
#
class postgresql::config {

  if $postgresql::config_file_path {
    file { $postgresql::config_file_path:
      ensure  => $postgresql::config_file_ensure,
      path    => $postgresql::config_file_path,
      mode    => $postgresql::config_file_mode,
      owner   => $postgresql::config_file_owner,
      group   => $postgresql::config_file_group,
      source  => $postgresql::config_file_source,
      content => $postgresql::manage_config_file_content,
      notify  => $postgresql::manage_config_file_notify,
      alias   => 'postgresql.conf',
    }
  }

  if $postgresql::init_file_template {
    file { $postgresql::init_file_path:
      ensure  => $postgresql::config_file_ensure,
      path    => $postgresql::init_file_path,
      mode    => $postgresql::config_file_mode,
      owner   => $postgresql::config_file_owner,
      group   => $postgresql::config_file_group,
      content => template($postgresql::init_file_template),
      notify  => $postgresql::manage_config_file_notify,
      alias   => 'postgresql.init.conf',
    }
  }

  if $postgresql::manage_hba_file_content {
    file { $postgresql::hba_file_path:
      ensure  => $postgresql::config_file_ensure,
      path    => $postgresql::hba_file_path,
      mode    => $postgresql::config_file_mode,
      owner   => $postgresql::config_file_owner,
      group   => $postgresql::config_file_group,
      content => $postgresql::manage_hba_file_content,
      notify  => $postgresql::manage_config_file_notify,
      alias   => 'postgresql.hba.conf',
    }
  }

  if $postgresql::config_dir_source {
    file { $postgresql::config_dir_path:
      ensure  => $postgresql::config_dir_ensure,
      path    => $postgresql::config_dir_path,
      source  => $postgresql::config_dir_source,
      recurse => $postgresql::config_dir_recurse,
      purge   => $postgresql::config_dir_purge,
      force   => $postgresql::config_dir_purge,
      notify  => $postgresql::manage_config_file_notify,
      alias   => 'postgresql.dir',
    }
  }

}
