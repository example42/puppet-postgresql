# Define: postgresql::import
#
# This defines downloads, extracts and imports into postgresql
# a dump file.
#
# == Variables
#
# [*source_url*]
#   The Url of the file to retrieve. Required.
#   Examples:
#   http://www.example42.com/backup_db.gz
#   file:///var/tmp/backup_db.gz
#
# [*extract_dir*]
#   The final destination where to unpack or copy what has been
#   downloaded. Default: the postgresql data dir
#
# [*extracted_file*]
#   The name of a directory or file created after the extraction
#   Needed only if its name is different from the downloaded file name
#   (without suffixes). Optional.
#
# [*path*]
#  Define the path for the exec commands.
#  Default: /bin:/sbin:/usr/bin:/usr/sbin
#
# [*exec_env*]
#   Define any additional environment variables to be used with the
#   exec commands. Note that if you use this to set PATH, it will
#   override the path attribute. Multiple environment variables
#   should be specified as an array.
#   Example: [ http_proxy=http://proxy.example42.com:3128 ]

# [*extract_command*]
#   The command used to extract the downloaded file.
#   By default is autocalculated according to the file extension
#
# [*database*]
#   The database where to import the data. If not define no explicit
#   database is used.
#
# [*flagfile*]
#   Path of the flagfile created when the import has been successful
#   Needed to avoid reimports at new Puppet runs.
#   Default: ${postgresql::data_dir}/restore_${name}.flag
#
# [*log*]
#   Path of the log of the import operations.
#   Default: ${postgresql::data_dir}/restore_${name}.log
#
# [*errorlog*]
#   Path of the error log of the import operations.
#   Default: ${postgresql::data_dir}/restore_${name}_error.log
#
# [*noops*]
#   If to actually execute the import. Default: noops
#   Set to true if you want to test a dry run
#
define postgresql::import (
  $source_url,
  $extract_command = '',
  $extract_dir     = '',
  $extracted_file  = '',
  $database        = '',
  $flagfile        = '',
  $log             = '',
  $errorlog        = '',
  $path            = '/bin:/sbin:/usr/bin:/usr/sbin',
  $user            = '',
  $exec_env        = [],
  $noops           = undef
) {

  include postgresql


  $real_extract_dir = $extract_dir ? {
    ''      => $postgresql::real_data_dir,
    default => $extract_dir,
  }

  $real_user = $user ? {
    ''      => $postgresql::process_user,
    default => $user,
  }

  $real_flagfile = $flagfile ? {
    ''      => "${postgresql::real_data_dir}/restore_${name}.flag",
    default => $flagfile,
  }

  $real_log = $log ? {
    ''      => "${postgresql::real_data_dir}/restore_${name}.log",
    default => $log,
  }

  $real_errorlog = $errorlog ? {
    ''      => "${postgresql::real_data_dir}/restore_${name}_error.log",
    default => $errorlog,
  }

  $source_filetype = url_parse($source_url,'filetype')
  $source_filedir = url_parse($source_url,'filedir')
  $source_filename = url_parse($source_url,'filename')
  $source_scheme = url_parse($source_url,'scheme')
  $source_path = url_parse($source_url,'path')

  $real_extract_command = $extract_command ? {
    ''      => $source_filetype ? {
      '.tgz'     => 'tar -zxf',
      '.gz'      => 'gunzip',
      '.tar'     => 'tar -xf',
      '.zip'     => 'unzip',
      default    => 'tar -zxf',
    },
    false   => false,
    default => $extract_command,
  }

  $real_extracted_file = $extracted_file ? {
    ''      => $source_scheme ? {
      'file'  => $source_path,
      default => $source_filedir,
    },
    default => $extracted_file,
  }

  $before_extract = $real_extract_command ? {
    false   => undef,
    default => Exec["Extract_postgres_import_${name}"],
  }

  if $source_scheme != 'file' {
    exec { "Retrieve_${source_url}":
      cwd         => $real_extract_dir,
      command     => "wget ${source_url}",
      creates     => "${real_extract_dir}/${source_filename}",
      before      => $before_extract,
      timeout     => 3600,
      path        => $path,
      environment => $exec_env,
      noop        => $noops,
    }
  }

  if $real_extract_command {
    exec { "Extract_postgres_import_${name}":
      cwd         => $real_extract_dir,
      command     => "${real_extract_command} ${extract_dir}/${source_filename}",
      user        => $real_user,
      unless      => "ls ${real_extract_dir}/${real_extracted_file}",
      creates     => "${real_extract_dir}/${real_extracted_file}",
      before      => Exec["Import_${name}"],
      path        => $path,
      environment => $exec_env,
      timeout     => 3600,
      noop        => $noops,
    }
  }

  exec { "Import_${name}":
    cwd     => $real_extract_dir,
    user    => $postgresql::process_user,
    path    => $path,
    creates => $real_flagfile,
    require => Service['postgresql'],
    command => "psql -f ${real_extracted_file} ${database} > ${real_log} 2> ${real_errorlog} && touch ${real_flagfile}",
    timeout => 3600,
    noop    => $noops,
  }

}

