class clamav::unofficial (
  $securite_key       = 'not_set',
  $malwarepatrol_key  = 'not_set',
  $malwarepatrol_list = 'clamav_basic',
  $default_db_rating  = 'LOW',
) {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['clamav-freshclam'],
  }

  # == Deploy script
  file { '/usr/local/bin/clamav-unofficial-sigs.sh':
    source  => 'puppet:///modules/clamav/unofficial-sigs/clamav-unofficial-sigs.sh',
    mode    => '0775',
  }

  # == Config
  file { '/etc/clamav-unofficial-sigs':
    ensure => directory,
  }

  file { '/etc/clamav-unofficial-sigs/master.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/unofficial-sigs/config/master.conf',
    require => File['/etc/clamav-unofficial-sigs/master.conf'],
  }

  file { '/etc/clamav-unofficial-sigs/os.conf':
    ensure  => file,
    source  => 'puppet:///modules/clamav/unofficial-sigs/config/os.ubuntu.conf',
    require => File['/etc/clamav-unofficial-sigs/master.conf'],
  }

  file { '/etc/clamav-unofficial-sigs/user.conf':
    ensure  => file,
    content => template('clamav/unofficial-sigs/config/user.conf.erb'),
    require => File['/etc/clamav-unofficial-sigs/master.conf'],
  }

  # == Log file
  file { '/var/log/clamav/unofficial.log':
    ensure => file,
  }

  # == Cron
  cron { 'clamav-unofficial':
    ensure  => present,
    command => '/usr/local/bin/clamav-unofficial-sigs.sh > /dev/null 2>&1',
    user    => 'root',
    minute  => 5,
    require => File['/usr/local/bin/clamav-unofficial-sigs.sh','/etc/clamav-unofficial-sigs/user.conf','/var/log/clamav/unofficial.log'],
  }

}
