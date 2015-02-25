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
  $ensure = 'running',
  $user = 'hornetq',
  $install_type = 'stand-alone/non-clustered',
  $config_folder = '/etc/hornetq',
  $data_folder = '/data/hornetq',
  $run_folder = '/var/run/hornetq',
  $log_folder = '/var/log/hornetq',
  $java_home = '/usr/java/latest',
  $jnp_host = 'localhost',
  $jnp_port = '11099',
  $rmi_port = '11098',
  $min_mem = '512',
  $max_mem = '1024',
  $debug = 'FALSE',
){

  include stdlib

  anchor { 'hornetq::begin': }
  anchor { 'hornetq::end': }

  class { 'hornetq::package':
    version     => $version,
    versionlock => $versionlock
  }

  class { 'hornetq::config': 
    ensure        => $ensure,
    version       => $version,
    user          => $user,
    install_type  => $install_type,
    config_folder => $config_folder,
    data_folder   => $data_folder,
    run_folder    => $run_folder,
    log_folder    => $log_folder,
    java_home     => $java_home,
    jnp_host      => $jnp_host,
    jnp_port      => $jnp_port,
    rmi_port      => $rmi_port,
    min_mem       => $min_mem,
    max_mem       => $max_mem,
    debug         => $debug
  }

  class { 'hornetq::service':
    ensure => $ensure
  }

  Anchor['hornetq::begin'] -> Class['Hornetq::Package'] -> Class['Hornetq::Config'] ~> Class['Hornetq::Service'] -> Anchor['hornetq::end']

}
