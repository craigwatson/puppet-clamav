class clamav(
  Boolean $run_freshclam      = true,
  Boolean $include_unofficial = false,
) {

  if $facts['os']['name'] != 'Ubuntu' {
    fail "Unsupported operating system: ${facts[os][name]}"
  }

  include ::clamav::install
  include ::clamav::config
  include ::clamav::freshclam
  
  if $::clamav::include_unofficial == true {
    include ::clamav::unofficial
  }

  include ::clamav::service
}
