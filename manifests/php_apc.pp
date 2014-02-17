#
# MeetMe newrelic plugin for monitoring php-apc
#
class newrelic_plugin::php_apc(
  $scheme     = 'http',
  $host       = 'localhost',
  $port       = 80,
  $stats_path = '/apc_status',
  $verify_ssl = false,
  $enable     = true,
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_php_apc':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_php_apc.erb'),
    }
  }
}
