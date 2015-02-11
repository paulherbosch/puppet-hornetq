# Class: hornetq
#
# This module manages hornetq
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class hornetq(
  $version = undef,
  $versionlock = false,
  $ensure = 'running'
){

  include stdlib

  anchor { 'hornetq::begin': }
  anchor { 'hornetq::end': }

  class { 'hornetq::package':
    version     => $version,
    versionlock => $versionlock
  }

  class { 'hornetq::config': }

  class { 'hornetq::service':
    ensure => $ensure
  }

  Anchor['hornetq::begin'] -> Class['Hornetq::Package'] -> Class['Hornetq::Config'] ~> Class['Hornetq::Service'] -> Anchor['hornetq::end']

}
