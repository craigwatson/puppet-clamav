class clamav::config {

  File {
    owner => 'clamav',
    group => 'adm',
    mode  => '0644',
  }

  file { '/etc/clamav/freshclam.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/freshclam.conf',
    require => Package['clamav-freshclam'],
    notify  => Service['clamav-freshclam'],
  }

  file { '/etc/clamsmtpd.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/clamsmtpd.conf',
    require => Package['clamsmtp'],
    notify  => Service['clamsmtp'],
  }

  file { '/etc/clamav/clamd.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/clamd.conf',
    require => Package['clamav-daemon'],
    notify  => Service['clamav-daemon'],
  }

  file { '/var/run/clamav':
    ensure  => directory,
    mode    => '0755',
    require => Package['clamav-freshclam'],
  }
}
