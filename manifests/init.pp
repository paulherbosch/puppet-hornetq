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
  $service_state = 'running',
  $service_enable = true,
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
  $ping_timeout = '30',
  $log_level = 'INFO',
  $ping_timeout_action = 'RESTART'
){

  include stdlib

  anchor { 'hornetq::begin': }
  anchor { 'hornetq::end': }

  class { 'hornetq::package':
    version     => $version,
    versionlock => $versionlock
  }

  class { 'hornetq::config':
    version             => $version,
    user                => $user,
    install_type        => $install_type,
    config_folder       => $config_folder,
    data_folder         => $data_folder,
    log_folder          => $log_folder,
    java_home           => $java_home,
    jnp_host            => $jnp_host,
    jnp_port            => $jnp_port,
    rmi_port            => $rmi_port,
    min_mem             => $min_mem,
    max_mem             => $max_mem,
    debug               => $debug,
    ping_timeout        => $ping_timeout,
    log_level           => $log_level,
    ping_timeout_action => $ping_timeout_action
  }

  class { 'hornetq::service':
    ensure        => $service_state,
    version       => $version,
    enable        => $service_enable,
    user          => $user,
    config_folder => $config_folder,
    run_folder    => $run_folder,
  }

  Anchor['hornetq::begin'] -> Class['Hornetq::Package'] -> Class['Hornetq::Config'] ~> Class['Hornetq::Service'] -> Anchor['hornetq::end']

}
