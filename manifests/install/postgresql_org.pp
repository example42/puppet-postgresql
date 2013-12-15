# = Class: postgresql::install::postgresql_org
#
# This class installs the Officila postgresql.org repo
# Note: It uses rsources provided by example42 apt and yum modules.
#
class postgresql::install::postgresql_org {

  case $::osfamily {
    Ubuntu: {
      apt::repository { 'postgresql':
        url             => 'http://apt.postgresql.org/pub/repos/apt',
        distro          => "${::lsbdistcodename}-pgdg",
        repository      => 'main',
        key_url         => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
        key             => 'ACCC4CF8',
        keyring_package => 'pgdg-keyring',
      }
    }
    RedHat: {
      yum::managed_yumrepo { "pgdg${::postgresql::version}":
        descr          => "PostgreSQL ${postgresql::version_short} \$releasever - \$basearch",
        baseurl        => "http://yum.postgresql.org/${postgresql::version}/redhat/rhel-\$releasever-\$basearch",
        enabled        => 1,
        gpgcheck       => 1,
        gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG',
        gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-PGDG',
        priority       => 20,
      }
    }
    Solaris: { include postgresql::install::postgresql_org_solaris }
    default: {}
  }

}

