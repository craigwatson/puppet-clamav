class clamav(
  $run_freshclam      = true,
  $include_unofficial = false,
) {

  include ::clamav::install
  include ::clamav::service
  include ::clamav::config


  if $::clamav::include_unofficial == true {
    include ::clamav::unofficial
  }

  if $facts['os']['name'] != 'Ubuntu' {
    fail "Unsupported operating system: ${facts[os][name]}"
  }
}
