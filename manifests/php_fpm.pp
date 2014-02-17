#
# MeetMe newrelic plugin for monitoring php-fpm
#
class newrelic_plugin::php_fpm(
  $scheme     = 'http',
  $host       = 'localhost',
  $port       = 80,
  $stats_path = '/fpm_status',
  $enable     = true,
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_php_fpm':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_php_fpm.erb'),
    }
  }
}
