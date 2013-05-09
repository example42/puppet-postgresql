# Quick implementation with database creation and default role grants
# Requires a db name ($name) and a role. To be adapted for specific cases
#
define postgresql::dbcreate (
  $role,
  $encoding     = 'SQL_ASCII',
  $locale       = 'C',
  $template     = 'template1',
  $password     = '',
  $conntype     = 'host',
  $address      = '127.0.0.1/32',
  $auth_method  = 'md5',
  $auth_options = ''
) {

  include postgresql

  exec { "role_${name}":
    user    => $postgresql::process_user,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    unless  => "echo \\\\dg | psql | grep ${role} 2>/dev/null",
    command => "echo \"create role ${role} nosuperuser nocreatedb nocreaterole noinherit nologin ; alter role ${role} nosuperuser nocreatedb nocreaterole noinherit login encrypted password '${password}'; grant ${name} to ${role}; create database ${name} with OWNER=${role} TEMPLATE=${template} ENCODING='${encoding}' LC_COLLATE='${locale}' LC_CTYPE='${locale}';\" | /usr/bin/psql",
    require => [Service['postgresql']],
  }

  postgresql::hba { "hba_${name}":
    ensure   => 'present',
    type     => $conntype,
    database => $name,
    user     => $role,
    address  => $address,
    method   => $auth_method,
    option   => $auth_options,
  }

}
