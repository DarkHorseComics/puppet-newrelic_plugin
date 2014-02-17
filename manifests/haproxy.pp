#
# MeetMe newrelic plugin for monitoring HAProxy
#
class newrelic_plugin::haproxy (
  $scheme     = 'http',
  $host       = 'localhost',
  $port       = 80,
  $stats_path = 'haproxy?stats;csv',
  $verify_ssl = true,
  $enable     = true,
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_haproxy':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_haproxy.erb'),
    }
  }
}
