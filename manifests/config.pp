#
# Config for newrelic plugins
#
class newrelic_plugin::config {
  file { ['/usr/local/newrelic', '/etc/newrelic']:
    ensure => directory,
  }
}
