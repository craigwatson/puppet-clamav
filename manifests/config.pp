class clamav::config {
  file {
    '/etc/clamsmtpd.conf':
      source  => 'puppet:///modules/clamav/clamsmtpd.conf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['clamsmtp'],
      notify  => Service['clamsmtp'];

    '/etc/clamav/clamd.conf':
      source  => 'puppet:///modules/clamav/clamd.conf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['clamav-freshclam'],
      notify  => Service['clamav-daemon'];

    '/var/run/clamav/':
      ensure  => directory,
      owner   => 'clamav',
      group   => 'root',
      mode    => '0755',
      require => Package['clamav-daemon'],
      notify  => Service['clamav-daemon'];

    '/etc/clamav/freshclam.conf':
      source  => 'puppet:///modules/clamav/freshclam.conf',
      owner   => 'clamav',
      group   => 'adm',
      mode    => '0444',
      require => Package['clamav-freshclam'];
  }

  if $::clamav::run_freshclam == true {
    File['/etc/clamav/freshclam.conf']{
      notify  => Exec['freshclam-init'],
    }
  }

  cron { 'freshclam':
    ensure  => present,
    command => '/usr/bin/freshclam --quiet > /dev/null 2>&1',
    user    => 'root',
    minute  => '0',
    hour    => '1',
    require => [File['/etc/clamav/freshclam.conf'],Package['clamav-freshclam']],
  }
}
