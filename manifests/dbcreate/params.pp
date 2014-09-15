#
# helper class so we can set defaults using hiera
#
# this class never gets called, it is only used by dbcreate.
# use in hiera like this:
#   postgresql::dbcreate::params::encoding: 'UTF8'
#   postgresql::dbcreate::params::locale:   'en_US.UTF-8'
#   postgresql::dbcreate::params::template: 'template0'

#
class postgresql::dbcreate::params (
  $encoding     = 'SQL_ASCII',
  $locale       = 'C',
  $template     = '',
) {
}
