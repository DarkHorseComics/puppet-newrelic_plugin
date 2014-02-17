# Class: newrelic_plugin::params
#
# This module manages newrelic agent parameters
#
# Parameters:
# There are no parameters for this class
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class is not to be used directly
class newrelic_plugin::params {
  $postgres_python_package = 'psycopg2'

  case $::osfamily {
    'RedHat': {
      $postgres_lib_package    = 'postgresql-libs'
      $java_jre_package        = 'java-1.7.0-openjdk'
    }
    'Debian': {
      $postgres_lib_package    = 'libpq-dev'
      $java_jre_package        = 'openjdk-7-jre-headless'
    }
    default: {
      fail('Unsupported OS family')
    }
  }
}
