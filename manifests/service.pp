class clamav::service {
  Service {
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  if $clamav::run_freshclam == true {
    $daemon_require = [Exec['freshclam-init'],File['/etc/clamav/clamd.conf']]
  } else {
    $daemon_require = File['/etc/clamav/clamd.conf']
  }

  service { 'clamav-daemon':
    require => $daemon_require,
  }

  service { 'clamsmtp':
    require => File['/etc/clamsmtpd.conf'],
  }
}
