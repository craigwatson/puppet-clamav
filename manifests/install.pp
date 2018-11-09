class clamav::install {
  package { ['clamsmtp','clamav-freshclam','clamav-daemon']:
    ensure => present,
  }
}
