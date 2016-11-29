class clamav::unofficial (
  $securite_key,
  $malwarepatrol_key,
) {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['clamav-freshclam'],
  }

  file {
    '/usr/local/man/clamav-unofficial-sigs.8':
      source  => 'puppet:///modules/clamav/unofficial-sigs/clamav-unofficial-sigs.8';

    '/usr/local/bin/clamav-unofficial-sigs.sh':
      source  => 'puppet:///modules/clamav/unofficial-sigs/clamav-unofficial-sigs.sh',
      mode    => '0775';

    '/var/log/clamav/unofficial.log':
      ensure => file;

    '/usr/local/etc/clamav-unofficial-sigs.conf':
      content => template('clamav/clamav-unofficial-sigs.conf.erb');
  }

  cron { 'clamav-unofficial':
    ensure  => present,
    command => '/usr/local/bin/clamav-unofficial-sigs.sh -c /usr/local/etc/clamav-unofficial-sigs.conf > /dev/null 2>&1',
    user    => 'root',
    minute  => 5,
    require => File['/usr/local/bin/clamav-unofficial-sigs.sh','/usr/local/etc/clamav-unofficial-sigs.conf','/var/log/clamav/unofficial.log'],
  }

}
