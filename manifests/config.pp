class hornetq::config(
  $ensure,
  $version,
  $user,
  $install_type,
  $config_folder,
  $data_folder,
  $run_folder,
  $log_folder,
  $java_home,
  $jnp_host,
  $jnp_port,
  $rmi_port,
  $min_mem,
  $max_mem,
  $debug,
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  $hornetq_major_version = regsubst($version, '^(\d+\.\d+).*','\1')
  notice("hornetq_major_version = ${hornetq_major_version}")
  $package_version = regsubst($hornetq_major_version, '\.', '', 'G')

  file { ${config_folder} :
    ensure => directory,
  }

  file { "${config_folder}/hornetq${package_version}-wrapper.conf":
    ensure  => $ensure,
    content => template("${module_name}/etc/hornetq/hornetq-wrapper.conf.erb"),
    require => File[${config_folder}]
  }

}
