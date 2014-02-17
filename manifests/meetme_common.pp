#
# Common class for all MeetMe newrelic plugins
#
class newrelic_plugin::meetme_common(
  $newrelic_license_key = undef,
  $user                 = 'newrelic',
  $polling_interval     = 60,
  $enabled              = true,
) {

  # Include concat for template concatenation
  include concat::setup

  # Ensure necessary python packages are installed
  ensure_resource('class', 'python', { 
    pip        => true,
    dev        => true,
    virtualenv => true,
  })

  python::pip{'git+git://github.com/MeetMe/newrelic-plugin-agent':
    ensure   => present,
  }

  file { '/etc/init.d/newrelic_plugin_agent':
    ensure  => link,
    target  => '/opt/newrelic_plugin_agent/newrelic_plugin_agent.deb',
    require => Python::Pip['git+git://github.com/MeetMe/newrelic-plugin-agent'],
  }

  # Ensure init script is executable
  file { '/opt/newrelic_plugin_agent/newrelic_plugin_agent.deb':
    mode => '0755',
  }

  if (!defined(User['newrelic'])) {
    user{ 'newrelic':
      ensure     => present,
      managehome => false,
    }
  }

  file { ['/var/run/newrelic','/var/log/newrelic']:
    ensure  => directory,
    owner   => 'newrelic',
    group   => 'newrelic',
    require => User['newrelic'],
  }

  concat { '/etc/newrelic/newrelic_plugin_agent.cfg':
    mode   => '0644',
    notify => Service['newrelic_plugin_agent'],
  }

  concat::fragment { 'newrelic_plugin_header':
    order   => '01',
    target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
    content => template('newrelic_plugin/meetme/_plugin_header.erb'),
  }

  concat::fragment { 'newrelic_plugin_footer':
    order   => '999',
    target  => '/etc/newrelic/newrelic_plugin_agent.cfg',
    content => template('newrelic_plugin/meetme/_plugin_footer.erb'),
  }

  # Setup service
  $service_ensure = $enabled ? {
    true  => 'running',
    false => 'stopped',
  }

  service { 'newrelic_plugin_agent':
    ensure   => $service_ensure,
    enable   => $enabled,
    require  => [
      File['/etc/init.d/newrelic_plugin_agent'],
    ]
  }

}
