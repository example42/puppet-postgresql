# Define: postgresql::db
#
# Add a postgresql database
#
# [*db_name*]
#  Database name
#  Default: $name
#
# [*owner*]
#  Database owner
#  Default: unset
#
# [*template*]
#  Database template to used
#  Default: unset
#
define postgresql::db (
  $db_name         = $name,
  $owner           = undef,
  $template        = undef,
) {

  # Generate query
  $manage_query_start = "CREATE DATABASE ${db_name}"

  if $owner == undef {
    $manage_query_owner = ""
  } else {
    $manage_query_owner = " OWNER ${owner}"
  }

  if $template == undef {
    $manage_query_template = ""
  } else {
    $manage_query_template = " TEMPLATE ${template}"
  }

  $manage_query_end = ";"

  $manage_query = "${manage_query_start}${manage_query_owner}${manage_query_template}${manage_query_end}"


  # Gerate options
  $manage_query_unless = "psql --list -t -A | grep -q \"^${db_name}|\""
  $manage_query_command = "echo \"${manage_query}\" | /usr/bin/psql"

  exec { "postgresql_db_${name}":
    user    => $postgresql::process_user,
    path    => '/bin:/usr/bin:/bin/usr/sbin:/sbin',
    unless  => $manage_query_unless,
    command => $manage_query_command,
    require => Service['postgresql'],
  }


}
