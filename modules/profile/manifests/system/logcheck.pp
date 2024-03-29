class profile::system::logcheck {
    include profile::system::logcheck::conf

    package { 'logcheck':
        ensure => purged,
    } ->
    Class['profile::system::logcheck::conf']
}

class profile::system::logcheck::conf {
    file { '/etc/logcheck/logcheck.conf':
        ensure => absent,
        owner => root,
        group => logcheck,
        mode => '640',
        source => 'puppet:///modules/profile/logcheck/logcheck.conf',
    }

    file { '/etc/logcheck/logcheck.logfiles':
        ensure => absent,
        owner => root,
        group => logcheck,
        mode => '640',
        source => 'puppet:///modules/profile/logcheck/logcheck.logfiles',
    }

    file { '/etc/logcheck/ignore.d.server':
        ensure => absent,
        owner => root,
        group => logcheck,
        recurse => true,
        source => 'puppet:///modules/profile/logcheck/ignore.d.server',
    }

    file { '/etc/logcheck/header.txt':
        ensure => absent,
    }
}
