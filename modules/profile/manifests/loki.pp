class profile::loki {
    package { 'loki':
        ensure => latest,
    }

    service { 'loki':
        enable => true,
        ensure => running,
        require => Package['loki'],
    }

    file { '/etc/loki/loki.yml':
        ensure => file,
        group => loki,
        source => 'puppet:///modules/profile/loki/loki.yml',
        require => Package['loki'],
        notify => Service['loki'],
    }
}
