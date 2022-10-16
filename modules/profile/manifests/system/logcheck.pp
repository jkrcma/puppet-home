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
    }

    file { '/etc/logcheck/logcheck.logfiles':
        ensure => absent,
    }

    file { '/etc/logcheck/ignore.d.server':
        ensure => absent,
        recurse => true,
        force => true,
    }

    file { '/etc/logcheck':
        ensure => absent,
        recurse => true,
        force => true,
    }

    file { '/etc/logcheck/header.txt':
        ensure => absent,
    }

    file { ['/tmp/journal', '/tmp/syslog']:
        ensure => absent,
    }
}
