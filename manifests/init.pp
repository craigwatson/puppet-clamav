class clamav {
  include clamav::install
  include clamav::service
  include clamav::config
  include clamav::unofficial

  Class['clamav::install'] ->
  Class['clamav::config'] ->
  Class['clamav::service'] ->
  Class['clamav::unofficial']
}
