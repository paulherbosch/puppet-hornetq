class hornetq::service(
  $ensure = 'running',
  $version = undef,
  $user = undef,
  $config_folder = undef,
  $run_folder = undef,
  $log_folder = undef
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_re($ensure, '^running$|^stopped$')
  $hornetq_major_version = regsubst($version, '^(\d+\.\d+).*','\1')
  notice("hornetq_major_version = ${hornetq_major_version}")
  $package_version = regsubst($hornetq_major_version, '\.', '', 'G')
  $real_run_folder = "${run_folder}${package_version}"
  $real_log_folder = "${log_folder}${package_version}"

  file { "/etc/init.d/hornetq${package_version}":
    ensure  => file,
    content => template("${module_name}/etc/init.d/hornetq.erb"),
  }

  file { [$real_run_folder,$real_log_folder]:
    ensure => directory,
    owner  => $user,
    group  => $user
  }

  service { 'hornetq':
    ensure     => $ensure,
    hasstatus  => true,
    hasrestart => true,
    require    => File[$real_run_folder,$real_log_folder,"/etc/init.d/hornetq${package_version}"]
  }

}
