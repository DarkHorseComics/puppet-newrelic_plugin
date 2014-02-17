#
# MeetMe newrelic plugin for monitoring nginx
#
class newrelic_plugin::nginx (
  $scheme     = 'http',
  $host       = 'localhost',
  $port       = 80,
  $stats_path = '/nginx_stub_status',
  $verify_ssl = true,
  $enable     = true,
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_nginx':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_nginx.erb'),
    }
  }
}
