class hornetq::service(
  $ensure = 'running',
  $version = undef,
  $user = undef,
  $config_folder = undef,
  $run_folder = undef,
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_re($ensure, '^running$|^stopped$')
  $hornetq_major_version = regsubst($version, '^(\d+\.\d+).*','\1')
  notice("hornetq_major_version = ${hornetq_major_version}")
  $package_version = regsubst($hornetq_major_version, '\.', '', 'G')
  $real_run_folder = "${run_folder}${package_version}"

  file { "/etc/init.d/hornetq${package_version}":
    ensure  => $ensure,
    content => template("${module_name}/etc/init.d/hornetq.erb"),
  }

  file { [$real_run_folder,'/var/log/hornetq']:
    ensure => 'present',
    owner  => $user,
    group  => $user
  }

  service { 'hornetq':
    ensure     => $ensure,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/var/run/hornetq','/var/log/hornetq',"/etc/init.d/hornetq${package_version}"]
  }

}
