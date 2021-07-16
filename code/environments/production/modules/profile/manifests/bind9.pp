class profile::bind9 {
    # install bind and enable the service
    package { 'bind9':
        ensure => latest,
    }
    service { 'bind9':
        enable => true,
        ensure => running,
        require => Package['bind9'],
    }

    # ensure config files
    file { '/etc/bind':
        ensure => directory,
    }
    file { '/etc/bind/named.conf.default-zones':
        ensure => file,
        source => 'puppet:///modules/profile/bind9/named.conf.default-zones',
        require => File['/etc/bind'],
        notify => Service['bind9'],
    }
    file { '/etc/bind/named.conf.local':
        ensure => file,
        source => 'puppet:///modules/profile/bind9/named.conf.local',
        require => File['/etc/bind/zones'],
        notify => Service['bind9'],
    }
    file { '/etc/bind/named.conf.options':
        ensure => file,
        source => 'puppet:///modules/profile/bind9/named.conf.options',
        notify => Service['bind9'],
    }
    file { '/etc/bind/zones':
        ensure => directory,
        recurse => true,
        source => 'puppet:///modules/profile/bind9/zones',
        notify => Service['bind9'],
    }

    # ensure runtime directory
    file { '/var/cache/bind':
        ensure => directory,
        group => bind,
        mode => '0775',
        require => Package['bind9'],
    }
}
