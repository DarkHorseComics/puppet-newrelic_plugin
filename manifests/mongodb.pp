#
# MeetMe newrelic plugin for monitoring MongoDB
#
# example:
# newrelic_plugin::mongodb { 'mongo':
#   admin_user     => 'some_user',
#   admin_password => 'some_pass',
#   databases      => {
#     'db1'        => {'username'  => 'user', password => 'password' },
#     'db2'        => {'username'  => 'otheruser', password => 'otherpassword' },
#   },
# }
#
class newrelic_plugin::mongodb (
  $host            = 'localhost',
  $port            = 27017,
  $host_name       = $::hostname,
  $admin_user      = undef,
  $admin_password  = undef,
  $databases       = undef,
  $enable          = true,
) {

  ensure_packages( ['build-essential', 'python-dev'] )
  if $enable {
    concat::fragment { 'newrelic_plugin_mongodb':
      target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
      content => template('newrelic_plugin/meetme/_mongodb.erb'),
    }
  }

  python::pip{ 'pymongo':
    ensure  => present,
  }
}
