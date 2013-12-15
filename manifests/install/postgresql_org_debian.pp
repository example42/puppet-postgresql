# = Class: postgresql::install::postgresql_org_debian
#
# This class installs the Official postgresql.org repo for Debian family
# Note: It uses rsources provided by example42 apt module.
#
class postgresql::install::postgresql_org_debian {

  apt::repository { 'postgresql':
    url             => 'http://apt.postgresql.org/pub/repos/apt',
    distro          => "${::lsbdistcodename}-pgdg",
    repository      => 'main',
    key_url         => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
    key             => 'ACCC4CF8',
    keyring_package => 'pgdg-keyring',
  }

}
