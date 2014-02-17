#
# MeetMe newrelic plugin for monitoring rabbitmq
#
class newrelic_plugin::rabbitmq (
  $host       = 'localhost',
  $port       = 15672,
  $user       = undef,
  $password   = undef,
  $verify_ssl_cert = false,
  $enable     = true,
) {

  if $enable {
    $plugin_name = "rabbitmq@${::hostname}"
    concat::fragment { 'newrelic_plugin_rabbitmq':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_rabbitmq.erb'),
    }
  }
}
