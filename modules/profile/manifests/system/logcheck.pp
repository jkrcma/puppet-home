class profile::system::logcheck {
    include profile::system::logcheck::conf

    package { 'syslog-summary':
        ensure => latest,
    }

    package { 'logcheck':
        ensure => latest,
        require => Package['exim4'],
    } ->
    User <| title == 'logcheck' |> { groups +> 'systemd-journal' } ->
    Class['profile::system::logcheck::conf']
}

class profile::system::logcheck::conf {
    file { '/etc/logcheck/logcheck.conf':
        ensure => file,
        owner => root,
        group => logcheck,
        mode => '640',
        source => 'puppet:///modules/profile/logcheck/logcheck.conf',
    }

    file { '/etc/logcheck/logcheck.logfiles':
        ensure => file,
        owner => root,
        group => logcheck,
        mode => '640',
        source => 'puppet:///modules/profile/logcheck/logcheck.logfiles',
    }

    file { '/etc/logcheck/ignore.d.server':
        ensure => directory,
        owner => root,
        group => logcheck,
        recurse => true,
        source => 'puppet:///modules/profile/logcheck/ignore.d.server',
    }
}
