class hornetq::package(
  $version = undef,
  $versionlock = false
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_bool($versionlock)

  $hornetq_major_version = regsubst($version, '^(\d+\.\d+).*','\1')
  notice("hornetq_major_version = ${hornetq_major_version}")
  $package_version = regsubst($hornetq_major_version, '\.', '', 'G')

  package { "hornetq${package_version}":
    ensure => $version
  }

  case $versionlock {
    true: {
      packagelock { "hornetq${package_version}": }
    }
    false: {
      packagelock { "hornetq${package_version}": ensure => absent }
    }
    default: { fail('Class[Hornetq::Package]: parameter versionlock must be true or false') }
  }

}
