class profile::loki {
    package { 'loki':
        ensure => latest,
    }

    service { 'loki':
        enable => true,
        ensure => running,
        require => Package['loki'],
    }

    # Loki does multi-tenancy by default, by using "fake" we disable it
    # https://github.com/grafana/loki/issues/5459
    file { '/etc/loki/alerts':
        ensure => directory,
    }
    file { '/etc/loki/alerts/fake':
        ensure  => directory,
        recurse => true,
        purge   => true,
        source  => 'puppet:///modules/profile/loki/alerts',
        notify => Service['loki'],
    }

    file { '/var/lib/loki/tmp-alerts':
        ensure => directory,
        owner => loki,
        group => loki,
        mode => '0770',
        before => Service['loki']
    }

    file { '/etc/loki/loki.yml':
        ensure => file,
        group => loki,
        mode => '644',
        source => 'puppet:///modules/profile/loki/loki.yml',
        notify => Service['loki'],
    }
}
