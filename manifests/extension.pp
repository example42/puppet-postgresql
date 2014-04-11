# = Define: postgresql::extension
#
# This class manage postgresql extension.
#
# == Parameters:
#
# [*extensionname*]
#   Name of the extension
#   (Default: $name)
#
# [*database*]
#   (Default: '')
#
# [*absent*]
#   Set to 'true' to remove the extension
#   (Default: false)
#
# == Example:
#
# * create database named "my_bd" owned by "my_bd"
#
#   postgresql::db { 'my_bd': }
#
# * create database named "my_bd" owned by "root"
#
#   postgresql::db { 'my_bd':
#     owner => 'root',
#   }
#
# * remove a database named 'my_bd'
#
#   postgresql::db { 'my_bd':
#     absent => true,
#   }
#
define postgresql::extension(
  $extensionname = $name,
  $database      = '',
  $absent        = false
) {

  include 'postgresql'

  $bool_absent = any2bool($absent)

  $create_query = "CREATE EXTENSION ${extensionname};"
  $drop_query = "DROP EXTENSION ${extensionname};"

  $db_command = $bool_absent ? {
    true    => "echo \"${drop_query}\" | psql ${database}",
    default => "echo \"${create_query}\" | psql ${database}",
  }
  $cmd = "echo \\\\dx|psql ${database}|tail -n +4|awk '{print \$1}'|grep '^${extensionname}$'"
  $db_unless = $bool_absent ? {
    true  => undef,
    false => $cmd,
  }
  $db_onlyif = $bool_absent ? {
    true  => $cmd,
    false => undef,
  }

  $manage_require = $database ? {
    ''      => Package['postgresql'],
    default => [
      Postgresql::Db[$database],
      Package['postgresql']
    ],
  }

  exec { "postgres-manage-extension-${name}":
    user    => $postgresql::process_user,
    path    => '/usr/bin:/bin:/usr/bin:/sbin',
    unless  => $db_unless,
    onlyif  => $db_onlyif,
    command => $db_command,
    require => $manage_require,
  }
}
