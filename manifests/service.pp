class hornetq::service(
  $ensure = 'running',
  $version = undef,
  $enable = true,
  $user = undef,
  $config_folder = undef,
  $run_folder = undef,
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_re($ensure, '^running$|^stopped$|^unmanaged$')
  $hornetq_major_version = regsubst($version, '^(\d+\.\d+).*','\1')
  notice("hornetq_major_version = ${hornetq_major_version}")
  $package_version = regsubst($hornetq_major_version, '\.', '', 'G')
  $real_run_folder = "${run_folder}${package_version}"

  if ($operatingsystemmajrelease < 7) {
    file { "/etc/init.d/hornetq${package_version}":
      ensure  => file,
      mode    => '0755',
      content => template("${module_name}/etc/init.d/hornetq.erb"),
    }
  }

  file { [$real_run_folder]:
    ensure => directory,
    owner  => $user,
    group  => $user
  }

  case $ensure {
    'running', 'stopped': {
      service { "hornetq${package_version}":
        ensure     => $ensure,
        enable     => $enable,
        hasstatus  => true,
        hasrestart => true,
        require    => File[$real_run_folder, "/etc/init.d/hornetq${package_version}"]
      }
    }
    'unmanaged': {
      notice('Class[hornetq::service]: service is currently not being managed')
    }
    default: {
      fail('Class[hornetq::service]: parameter ensure must be running, stopped or unmanaged')
    }
  }

}
