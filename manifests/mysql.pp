#
# Newrelic MySQL Agent
#
# Download newrelic mysql plugin and untar to /usr/local/newrelic/mysql
# - Setup all config files and init scripts
# - Create MySQL user and permissions
#
class newrelic_plugin::mysql(
  $mysql_user = 'newrelic',
  $mysql_root_pass = undef,
  $mysql_plugin_pass = '*B8B274C6AF8165B631B4B517BD0ED2694909F464',
  $mysql_name = 'mysql',
  $host_name = $::hostname,
  $newrelic_license_key = undef,
  $plugin_path = '/usr/local/newrelic/mysql',
  $enabled = true,
) {

  # Install java
  ensure_packages( ['openjdk-7-jre-headless',] )

  archive { 'newrelic_plugin_mysql':
    ensure              => present,
    url                 => 'https://raw.github.com/newrelic-platform/newrelic_mysql_java_plugin/master/dist/newrelic_mysql_plugin-1.0.9.tar.gz',
    digest_string       => 'ba561fe5040f7c333969d327cd43d6d8',
    target              => $plugin_path,
    extra_extract_flags => '--strip-components=1',
    onlyif              => "test ! -d ${plugin_path}",
  }

  # Create user for newrelic plugin if it does not exist
  exec { 'newrelic_plugin_mysql_user_create':
    require  => Archive['newrelic_plugin_mysql'],
    path     => '/usr/local/bin:/usr/bin:/bin',
    provider => 'shell',
    command  => "mysql -u root -p${mysql_root_pass} < ${plugin_path}/mysql_user.sql",
    unless   => "x=`mysql -u root -p${mysql_root_pass} -e 'select count(user) from mysql.user where user = \"newrelic\" ' -B --skip-column-names`; [ \"\$x\" -gt 0 ]",
  }

  file { 'newrelic_plugin_mysql_config':
    require => Archive['newrelic_plugin_mysql'],
    path    => "${plugin_path}/config/mysql.instance.json",
    content => template('newrelic_plugin/mysql/mysql_instance.json'),
  }

  file { 'newrelic_plugin_mysql_newrelic_key':
    require => Archive['newrelic_plugin_mysql'],
    path    => "${plugin_path}/config/newrelic.properties",
    content => template('newrelic_plugin/mysql/newrelic.properties'),
  }

  file { '/etc/init.d/newrelic-mysql-plugin':
    ensure => link,
    target => "${plugin_path}/etc/init.d/newrelic-mysql-plugin.debian",
  }

  # Ensure init script is executable
  file { '/usr/local/newrelic/mysql/etc/init.d/newrelic-mysql-plugin.debian':
    mode   => '0755',
  }

  file {"/usr/local/newrelic/mysql/etc/init.d/debian.patch": 
    source => "puppet:///modules/newrelic_plugin/mysql/debian.patch", 
    notify => Exec["apply-newrelic-mysql-init-patch"], 
  } 

  exec {"apply-newrelic-mysql-init-patch":
    cwd         => '/usr/local/newrelic/mysql/etc/init.d/',
    path        => '/usr/local/bin:/usr/bin:/bin',
    command     => "patch newrelic-mysql-plugin.debian -p0 < debian.patch",
    refreshonly => true,
  } 

  file { '/etc/default/newrelic-mysql-plugin':
    content => template('newrelic_plugin/mysql/init_default_params')
  }

  # Setup service
  $service_ensure = $enabled ? {
    true  => 'running',
    false => 'stopped',
  }

  service { 'newrelic-mysql-plugin':
    ensure   => $service_ensure,
    enable   => $enabled,
    require  => File['/etc/init.d/newrelic-mysql-plugin'],
  }
}
