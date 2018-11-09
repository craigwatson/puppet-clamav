class clamav::freshclam {

  file { '/etc/clamav/freshclam.conf':
    source  => 'puppet:///modules/clamav/freshclam.conf',
    owner   => 'clamav',
    group   => 'adm',
    mode    => '0444',
    require => Package['clamav-freshclam'],
  }

  if $::clamav::run_freshclam == true {
    exec { 'freshclam-init':
      command => '/usr/bin/freshclam --quiet > /dev/null 2>&1',
      creates => '/var/lib/clamav/main.cvd',
      require => File['/etc/clamav/freshclam.conf'],
      before  => Service['clamav-daemon'],
    }

    $cron_require = Exec['freshclam-init']

    Service <| title == 'clamav-daemon' |> {
      require => [Cron['freshclam'],File['/etc/clamav/clamd.conf']],
    }
  } else {
    $cron_require = File['/etc/clamav/freshclam.conf']
  }

  cron { 'freshclam':
    ensure  => present,
    command => '/usr/bin/freshclam --quiet > /dev/null 2>&1',
    user    => 'root',
    minute  => '0',
    hour    => '1',
    require => $cron_require,
  }
}
