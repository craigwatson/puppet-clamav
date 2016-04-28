class clamav(
  $run_freshclam = true,
) {
  include clamav::install
  include clamav::service
  include clamav::config
  include clamav::unofficial
}
