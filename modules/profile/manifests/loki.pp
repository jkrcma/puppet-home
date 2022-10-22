class profile::loki {
    package { 'loki':
        ensure => latest,
    }

    service { 'loki':
        enable => true,
        ensure => running,
        require => Package['loki'],
    }

    file { '/etc/loki/alerts':
        ensure  => directory,
        #recurse => true,
        #purge   => true,
        #source  => 'puppet:///modules/profile/prometheus/alerts',
        #notify => Service['prometheus'],
        require => Package['loki'],
    }

    file { '/var/lib/loki/tmp-alerts':
        ensure => directory,
        owner => loki,
        group => loki,
        mode => '0770',
        require => Package['loki'],
        before => Service['loki']
    }

    file { '/etc/loki/loki.yml':
        ensure => file,
        group => loki,
        mode => '644',
        source => 'puppet:///modules/profile/loki/loki.yml',
        require => Package['loki'],
        notify => Service['loki'],
    }
}
