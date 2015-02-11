class hornetq::package(
  $version = undef,
  $versionlock = false
){

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_bool($versionlock)

  package { 'hornetq':
    ensure => $version
  }

  case $versionlock {
    true: {
      packagelock { 'hornetq': }
    }
    false: {
      packagelock { 'hornetq': ensure => absent }
    }
    default: { fail('Class[Hornetq::Package]: parameter versionlock must be true or false') }
  }

}
