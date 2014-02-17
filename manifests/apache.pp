#
# MeetMe newrelic plugin for monitoring apache
#
class newrelic_plugin::apache(
  $scheme     = 'http',
  $host       = 'localhost',
  $port       = 80,
  $stats_path = '/server-status',
  $verify_ssl = true,
  $enable     = true,
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_apache':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_apache.erb'),
    }
  }
}
