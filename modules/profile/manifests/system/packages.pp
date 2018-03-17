class profile::system::packages ($gpg_key) {
    include profile::system::packages::exim4

    stage { 'apt':
        before => Stage['main']
    }

    file { 'den.list':
        path => '/etc/apt/sources.list.d/den.list',
        ensure => file,
        content => "deb http://build.den xenial/\n",
        notify => Exec['apt-key add'],
    }

    exec { 'apt-key add':
        command => "/bin/echo \"$gpg_key\" | /usr/bin/apt-key add -",
        refreshonly => true,
    }

    class { profile::system::packages::apt: stage => 'apt' }

    package { ['openssh-server', 'httpie']:
        ensure => latest,
    }

    service { 'ssh':
        enable => true,
        ensure => running,
        require => Package['openssh-server'],
    }
}

class profile::system::packages::apt {
    exec { 'apt-get update':
        command => "/usr/bin/apt-get update",
        onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1 | tail -1 )) )) <= 604800 ))'"
    }
}

class profile::system::packages::exim4 {
    package { 'exim4-daemon-light':
        ensure => latest,
    }

    # tmp
    package { 'exim4':
        ensure => purged,
    }

    service { 'exim4':
        enable => true,
        ensure => running,
        require => Package['exim4-daemon-light'],
    }

    file { '/etc/exim4/update-exim4.conf.conf':
        ensure => file,
        content => template('profile/packages/update-exim4.conf.conf.erb'),
        require => Package['exim4-daemon-light'],
        notify => Exec['exim4 config update'],
    }

    exec { 'exim4 config update':
        command => '/usr/sbin/update-exim4.conf',
        refreshonly => true,
        notify => Service['exim4'],
    }
}
