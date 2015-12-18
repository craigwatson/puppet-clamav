class clamav::service {
  service { ['clamav-daemon','clamsmtp']:
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => File['/etc/clamav/clamd.conf','/etc/clamsmtpd.conf'],
  }
}
