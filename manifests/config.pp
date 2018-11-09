class clamav::config {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['clamsmtp'],
  }

  file { '/etc/clamsmtpd.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/clamsmtpd.conf',
    require => Package['clamsmtp'],
  }

  file {'/etc/clamav/clamd.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/clamd.conf',
    require => Package['clamav-daemon'],
  }

  file { '/var/run/clamav':
    ensure  => directory,
    owner   => 'clamav',
    group   => 'root',
    mode    => '0755',
    require => Package['clamav-freshclam'],
  }
}
