class hornetq::config(
  $version = undef,
  $user = undef,
  $install_type = undef,
  $config_folder = undef,
  $data_folder = undef,
  $log_folder = undef,
  $java_home = undef,
  $jnp_host = undef,
  $jnp_port = undef,
  $rmi_port = undef,
  $min_mem = undef,
  $max_mem = undef,
  $debug = undef,
  $ping_timeout = undef,
  $log_level = undef,
  $ping_timeout_action = undef
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  $hornetq_major_version = regsubst($version, '^(\d+\.\d+).*','\1')
  $package_version = regsubst($hornetq_major_version, '\.', '', 'G')
  $real_log_folder = "${log_folder}${package_version}"

  file { [ $config_folder, $data_folder, $real_log_folder ]:
    ensure => directory,
    owner  => $user,
    group  => $user,
  }

  file { "${config_folder}/hornetq${package_version}-wrapper.conf":
    ensure  => file,
    content => template("${module_name}/etc/hornetq/hornetq-wrapper.conf.erb"),
    require => File[$config_folder,$real_log_folder]
  }

  file { "/opt/hornetq${package_version}/config/${install_type}/logging.properties":
    ensure  => file,
    owner   => $user,
    group   => $user,
    content => template("${module_name}/opt/hornetq${package_version}/config/${install_type}/logging.properties.erb"),
  }

}
