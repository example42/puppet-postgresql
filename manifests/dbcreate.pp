# Quick implementation with database creation and default role grants
# Requires a db name ($name) and a role. To be adapted for specific cases
#
define postgresql::dbcreate (
  $role,
  $encoding     = undef,
  $locale       = undef,
  $template     = undef,
  $password     = '',
  $conntype     = 'host',
  $address      = '127.0.0.1/32',
  $auth_method  = 'md5',
  $auth_options = '') {
  include postgresql

  $real_encoding = $encoding ? {
    undef => $postgresql::db_encoding,
    default => $encoding
  }
  $real_locale = $locale ? {
    undef => $postgresql::db_locale,
    default => $locale
  }

  $real_templace = $template ? {
    undef => $postgresql::db_template, #defaults to ''
    default => $template
  }

  exec { "role_${name}":
    user    => $postgresql::process_user,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    unless  => "echo \\\\dg | psql | grep ${role} 2>/dev/null",
    command => "echo \"create role \\\"${role}\\\" nosuperuser nocreatedb nocreaterole noinherit nologin ; alter role \\\"${role}\\\" nosuperuser nocreatedb nocreaterole noinherit login encrypted password '${password}'; grant ${name} to \\\"${role}\\\";\" | /usr/bin/psql",
    require => [Service['postgresql']],
  } -> exec { "db_${name}":
    user    => $postgresql::process_user,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    unless  => "psql --list -t -A | grep -q \"^${name}|\"",
    command => "echo \"create database \\\"${name}\\\" with OWNER=\\\"${role}\\\" TEMPLATE=${real_template} ENCODING='${real_encoding}' LC_COLLATE='${real_locale}' LC_CTYPE='${real_locale}';\" | /usr/bin/psql",
    require => [Service['postgresql']];
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
