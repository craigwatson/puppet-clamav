class clamav::install {
  package { 'clamsmtp':
    ensure => present,
  }

  package { 'clamav-freshclam':
    ensure => present,
  }

  package { 'clamav-daemon':
    ensure => present,
  }
}
