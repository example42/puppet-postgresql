# Class: postgresql::params
#
# This class defines default parameters used by the main module class postgresql
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to postgresql class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class postgresql::params {

  $use_postgresql_repo = false
  $install_prerequisites = true

  # Calculate OS version (without using lsb facts)
  $ossplit=split($::operatingsystemrelease, '[.]')
  $osver=$ossplit[0]

  ### Module's specific parameters
  $initdbcommand = ''

  $config_file_hba = ''

  $source_hba = ''
  $template_hba = ''
  $template_hba_header = 'postgresql/concat_hba_header.erb'
  $template_hba_footer = 'postgresql/concat_hba_footer.erb'

  ### Application related parameters

  $package = ''

  $service = ''

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'postgres',
    default                   => 'postmaster',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'postgres',
  }

  $config_dir = ''

  $config_file = ''

  $config_file_mode = $::operatingsystem ? {
    default => '0600',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'postgres',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'postgres',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/postgresql',
    default                   => '/etc/sysconfig/pgsql',
  }

  $pid_file = ''

  $data_dir = ''

  $log_dir = ''

  $log_file = ''

  $port = '5432'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = ''
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = '127.0.0.1'
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
