#
# = Class: postgresql::setup
#
# This class initializes postgresql database
#
class postgresql::setup {

  if $::postgresql::initdb_exec_command {
    exec { $::postgresql::initdb_exec_command:
      command => $::postgresql::initdb_exec_command,
      user    => $::postgresql::initdb_exec_user,
      #      creates => $::postgresql::config_file_path,
      path    => [ '/sbin', '/bin', '/usr/bin', '/usr/sbin' ],
      alias   => 'postgresql_initdb',
    }
  }

}
