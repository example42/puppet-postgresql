define postgresql::cluster(
  $cluster_name = $name,
  $version      = '8.4',
  $owner        = '',
  $group        = '',
  $locale       = '',
  $absent       = false,
) {

  include postgresql

  $bool_absent=any2bool($absent)

  $create_cmd = "pg_createcluster $version $cluster_name"

  $o_owner = $owner ? {
    ''      => "-u $postgresql::config_file_owner",
    default => "-u $owner",
  }

  $o_group = $group ? {
    ''      => "-g $postgresql::config_file_group",
    default => "-g $group",
  }

  $o_locale = $locale ? {
    ''      => '',
    default => "--locale=$locale",
  }
  $options = "$o_owner $o_group $o_locale"
  $full_create_cmd = "$create_cmd $options"

  $drop_cmd = "pg_dropcluster --stop $version $cluster_name"

  $ls_cmd = "pg_lsclusters -h|awk '{ print \$2 }'|grep $cluster_name"

  $manage_cmd = $bool_absent ? {
    true  => $drop_cmd,
    false => $full_create_cmd,
  }

  $manage_onlyif = $bool_absent ? {
    true  => $ls_cmd,
    false => undef,
  }

  $manage_unless = $bool_absent ? {
    false => $ls_cmd,
    true  => undef,
  }

  exec { "postgres-manage-cluster-${name}":
    command => $manage_cmd,
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    onlyif  => $manage_onlyif,
    unless  => $manage_unless,
    require => Package['postgresql'],
    notify  => $postgresql::manage_service_autorestart,
  }
}
