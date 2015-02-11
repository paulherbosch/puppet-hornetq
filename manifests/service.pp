class hornetq::service(
  $ensure = 'running'
) {

  validate_re($ensure, '^running$|^stopped$')

  #service { 'hornetq':
  #  ensure     => $ensure,
  #  hasstatus  => true,
  #  hasrestart => true
  #}

}
