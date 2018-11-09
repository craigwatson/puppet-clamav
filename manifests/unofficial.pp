class clamav::unofficial (
  String $config_os,
  Optional[String] $securite_key       = undef,
  Optional[String] $malwarepatrol_key  = undef,
  String           $malwarepatrol_list = 'clamav_basic',
  String           $default_db_rating  = 'LOW',
  Boolean          $enable_yara_rules  = true,
) {

  # == Deploy script
  file { '/usr/local/bin/clamav-unofficial-sigs.sh':
    ensure  => file,
    source  => 'puppet:///modules/clamav/unofficial-sigs/clamav-unofficial-sigs.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['clamav-freshclam'],
  }

  # == Config
  file { '/etc/clamav-unofficial-sigs':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['clamav-freshclam'],
  }

  file { '/etc/clamav-unofficial-sigs/master.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/clamav/unofficial-sigs/config/master.conf',
    require => File['/etc/clamav-unofficial-sigs'],
  }

  file { '/etc/clamav-unofficial-sigs/os.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/clamav/unofficial-sigs/config/os.${config_os}.conf",
    require => File['/etc/clamav-unofficial-sigs/master.conf'],
  }

  file { '/etc/clamav-unofficial-sigs/user.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('clamav/unofficial-sigs/config/user.conf.erb'),
    require => File['/etc/clamav-unofficial-sigs/master.conf'],
  }

  # == Log file
  file { '/var/log/clamav/unofficial.log':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['clamav-freshclam'],
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
