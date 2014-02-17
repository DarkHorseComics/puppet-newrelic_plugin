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
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_postgres':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_postgres.erb'),
    }
  }

  package { 'libpq-dev':
    ensure => present,
  }

  python::pip{ 'psycopg2':
    ensure  => present,
    require => Package['libpq-dev'],
  }

}
