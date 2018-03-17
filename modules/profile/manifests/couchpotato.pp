class profile::couchpotato {
    package { 'couchpotato':
        ensure => latest,
    } ->
    package { 'couchpotato-provider-trezzor':
        ensure => latest,
    }

    service { 'couchpotato':
        enable => true,
        ensure => running,
        require => Package['couchpotato'],
    }

    include nginx
    nginx::virtualhost { 'default':
        source => 'puppet:///modules/profile/couchpotato/default.nginx',
    }
}
