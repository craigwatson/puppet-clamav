class clamav::install {
  package { ['clamsmtp','clamav-freshclam']:
    ensure => present,
    notify => Exec['freshclam-init'],
  }

  exec { 'freshclam-init':
    command     => '/usr/bin/freshclam --quiet > /dev/null 2>&1',
    creates     => '/var/lib/clamav/main.cvd',
    require     => Package['clamav-freshclam'],
    refreshonly => true,
  }
}
