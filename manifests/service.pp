class clamav::service {
  Service {
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  service { 'clamav-freshclam':
    require => File['/etc/clamsmtpd.conf'],
  }

  service { 'clamav-daemon':
    require => File['/etc/clamav/clamd.conf'],
  }

  service { 'clamsmtp':
    require => File['/etc/clamsmtpd.conf'],
  }
}
