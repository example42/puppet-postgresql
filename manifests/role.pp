# = Define: postgresql::role
#
# This class create a role.
#
# == Parameters:
#
# [*rolename*]
#   The role name.
#   (Default: $name)
#
# [*superuser*]
#   True if role is superuser.
#   (Default: false)
#
# [*createrole*]
#   True if role can create role.
#   (Default: false)
#
# [*createdb*]
#   True if role can create database.
#   (Default: false)
#
# [*login*]
#   True if role can connect.
#   (Default: true)
#
# [*password*]
#   Desired password for role
#   (Default: '')
#
# [*absent*]
#   Set to 'true' to remove role
#   (Default: false)
#
# == Example:
#
# * create role named 'root'
#
#   postgresql::role { 'root': }
#
# * create a role named 'root' with 'password' as password.
#
#   postgresql::role { 'root':
#     password => 'password',
#   }
#
# * remove a role named 'root'
#
#   postgresql::db { 'root':
#     absent => true,
#   }
#
define postgresql::role(
  $rolename   = $name,
  $superuser  = false,
  $createrole = false,
  $createdb   = false,
  $login      = true,
  $password   = '',
  $absent     = false
) {

  include 'postgresql'

  $bool_absent = any2bool($absent)
  $bool_superuser = any2bool($superuser)
  $bool_createrole = any2bool($createrole)
  $bool_createbd = any2bool($createdb)
  $bool_login = any2bool($login)

  $initial_query = "CREATE ROLE \\\"$rolename\\\""

  $o_superuser = $bool_superuser ? {
    true  => 'SUPERUSER',
    false => 'NOSUPERUSER',
  }
  $o_createrole = $bool_createrole ? {
    true  => 'CREATEROLE',
    false => 'NOCREATEROLE',
  }
  $o_createdb = $bool_createbd ? {
    true  => 'CREATEDB',
    false => 'NOCREATEDB',
  }
  $o_login = $bool_login ? {
    true  => 'LOGIN',
    false => 'NOLOGIN',
  }
  $o_password = $password ? {
    ''      => '',
    default => "ENCRYPTED PASSWORD '${password}'",
  }
  $opts = "$o_superuser $o_createrole $o_createdb $o_login $o_password"
  $create_query = "$initial_query $opts;"
  $drop_query = "DROP ROLE \\\"${rolename}\\\""

  $db_command = $bool_absent ? {
    true    => "echo \"$drop_query\"|psql",
    default => "echo \"$create_query\"|psql",
  }
  $cmd = "echo \\\\dg|psql|tail -n +4|awk '{print \$1}'|grep '^${rolename}$'"
  $db_unless = $bool_absent ? {
    true  => undef,
    false => $cmd,
  }
  $db_onlyif = $bool_absent ? {
    true  => $cmd,
    false => undef,
  }
  $db_require = Package['postgresql']

  exec { "postgres-manage-role-${name}":
    user    => $postgresql::process_user,
    path    => '/usr/bin:/bin:/usr/bin:/sbin',
    unless  => $db_unless,
    onlyif  => $db_onlyif,
    command => $db_command,
    require => $db_require,
  }
}
