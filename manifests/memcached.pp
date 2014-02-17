#
# MeetMe newrelic plugin for monitoring memcached
#
class newrelic_plugin::memcached (
  $memcache_name = $::hostname,
  $host       = 'localhost',
  $port       = 11211,
  $verify_ssl = true,
  $enable     = true,
) {

  if $enable {
    concat::fragment { 'newrelic_plugin_memcached':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_memcached.erb'),
    }
  }
}
