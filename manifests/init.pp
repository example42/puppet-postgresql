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

  $version                   = undef,

  $package_name              = undef,
  $package_ensure            = 'present',

  $service_name              = undef,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = undef,
  $config_file_notify        = 'Class[postgresql::service]',
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

  $hba_file_path             = undef,
  $hba_file_template         = undef,
  $hba_file_content          = undef,
  $hba_file_options_hash     = { } ,

  $config_dir_path           = undef,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $conf_hash                 = undef,

  $initdb_exec_command       = undef,

  $install_class             = 'postgresql::install',
  $config_class              = 'postgresql::config',
  $setup_class               = 'postgresql::setup',
  $service_class             = 'postgresql::service',

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $process_user              = undef,
  $log_dir_path              = undef,
  $log_file_path             = undef,
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
  $manage_hba_file_content = default_content($hba_file_content, $hba_file_template)
  $version_short = regsubst($version,'\.','')

  $manage_config_file_notify  = $config_file_notify ? {
    'undef'         => undef,
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


  # Classes and resources

  include $postgresql::install_class
  include $postgresql::config_class
  include $postgresql::setup_class
  include $postgresql::service_class

  anchor { 'postgresql::server::start': }
  anchor { 'postgresql::server::end': }

  Anchor['postgresql::server::start'] ->
  Class[$postgresql::install_class] ->
  Class[$postgresql::config_class] ->
  Class[$postgresql::setup_class] ->
  Class[$postgresql::service_class] ->
  Anchor['postgresql::server::end']

  if $conf_hash {
    create_resources('postgresql::conf', $conf_hash)
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

