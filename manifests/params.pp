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

  ### Module's specific parameters
  $initdbcommand = $operatingsystem ? {
    default => 'service postgresql initdb',
  }

  $configfilehba = $operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/postgresql/8.4/main/pg_hba.conf',
    default => '/var/lib/pgsql/data/pg_hba.conf',
  }

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/       => 'postgresql-8.4',
    /(?i:RedHat|Centos|Scientific)/ => 'postgresql84-server',
    default                         => 'postgresql',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Mint)/        => 'postgresql',
    /(?i:Ubuntu)/             => $::operatingsystemrelease ? {
      '12.04' => 'postgresql',
      default => 'postgresql-8.4',
    },
    default                   => 'postgresql',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'postgres',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'postgres',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/postgresql/8.4/main',
    default                   => '/var/lib/pgsql/data',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/postgresql/8.4/main/postgresql.conf',
    default                   => '/var/lib/pgsql/data/postgresql.conf',
  }

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

  $pid_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/run/postgresql/8.4-main.pid',
    default                   => '/var/lib/pgsql/data/postmaster.pid',
  }

  $data_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/lib/postgresql/8.4/main',
    default                   => '/var/lib/pgsql',
  }

  $log_dir = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific)/ => '/var/lib/pgsql/data/pg_log',
    default                         => '/var/log/postgresql',
  }

  $log_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/       => '/var/log/postgresql/postgresql-8.4-main.log',
    /(?i:RedHat|Centos|Scientific)/ => '/var/lib/pgsql/data/pg_log/postgresql*.log',
    default                         => '/var/lib/pgsql/data/pg_log/postgresql*.log',
  }

  $port = '5432'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = 'false'
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
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
