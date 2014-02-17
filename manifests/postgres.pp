#
# MeetMe newrelic plugin for monitoring postgres
#
class newrelic_plugin::postgres (
  $host       = 'localhost',
  $port       = 5432,
  $user       = undef,
  $password   = undef,
  $dbname     = undef,
  $superuser  = false,
  $enable     = true,
) inherits newrelic_plugin::params {

  if $enable {
    concat::fragment { 'newrelic_plugin_postgres':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_postgres.erb'),
    }
  }

  package { $::newrelic_plugin::params::postgres_lib_package:
    ensure => present,
  }

  python::pip{ $::newrelic_plugin::params::postgres_lib_package:
    ensure  => present,
    require => Package[$::newrelic_plugin::params::postgres_lib_package],
  }

}
