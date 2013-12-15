#
# = Class: postgresql
#
# This class installs and manages postgresql
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class postgresql (

  $package_name              = undef,
  $package_ensure            = 'present',

  $service_name              = undef,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = undef,
  $config_file_require       = 'Package[postgresql]',
  $config_file_notify        = 'Service[postgresql]',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = { } ,
  $config_file_owner         = undef,
  $config_file_group         = undef,
  $config_file_mode          = undef,

  $init_file_path            = undef,
  $init_file_template        = undef,
  $init_file_options_hash    = { } ,

  $config_dir_path           = undef,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $conf_hash                 = undef,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $process_user              = undef,
  $tcp_port                  = undef,
  $udp_port                  = undef,

  ) {


  # Class variables validation and management

  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify  = $config_file_notify ? {
    'class_default' => 'Service[postgresql]',
    ''              => undef,
    default         => $config_file_notify,
  }

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable ? {
      ''      => undef,
      'undef' => undef,
      default => $service_enable,
    }
    $manage_service_ensure = $service_ensure ? {
      ''      => undef,
      'undef' => undef,
      default => $service_ensure,
    }
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Dependency class

  if $postgresql::dependency_class {
    include $postgresql::dependency_class
  }


  # Resources managed

  if $postgresql::package_name {
    package { $postgresql::package_name:
      ensure   => $postgresql::package_ensure,
      name     => $postgresql::package_name,
      alias    => '$postgresql',
    }
  }

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
      require => $postgresql::config_file_require,
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
      require => $postgresql::config_file_require,
      alias   => 'postgresql.init.conf',
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
      require => $postgresql::config_file_require,
      alias   => 'postgresql.dir',
    }
  }

  if $postgresql::service_name {
    service { $postgresql::service_name:
        ensure     => $postgresql::manage_service_ensure,
        name       => $postgresql::service_name,
        enable     => $postgresql::manage_service_enable,
        alias      => '$postgresql',
      }
    }


  # Extra classes

  if $conf_hash {
    create_resources('postgresql::conf', $conf_hash)
  }

  if $postgresql::my_class {
    include $postgresql::my_class
  }

  if $postgresql::monitor_class {
    class { $postgresql::monitor_class:
      options_hash => $postgresql::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $postgresql::firewall_class {
    class { $postgresql::firewall_class:
      options_hash => $postgresql::firewall_options_hash,
      scope_hash   => {},
    }
  }

}

