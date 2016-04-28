class clamav::install {
  package { ['clamsmtp','clamav-freshclam']:
    ensure => present,
  }

  if $::clamav::run_freshclam == true {
    exec { 'freshclam-init':
      command     => '/usr/bin/freshclam --quiet > /dev/null 2>&1',
      creates     => '/var/lib/clamav/main.cvd',
      require     => File['/etc/clamav/freshclam.conf'],
      refreshonly => true,
    }
  }
}
