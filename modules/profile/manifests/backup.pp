class profile::backup::rsyncd (String $secrets = undef) {
    package { 'rsync':
        ensure => latest,
    }

    service { 'rsync':
        enable => true,
        ensure => running,
        require => Package['rsync'],
    }

    file { '/etc/rsyncd.conf':
        source => 'puppet:///modules/profile/backup/rsyncd.conf',
        require => Package['rsync'],
        notify => Service['rsync'],
    }

    file { '/etc/rsyncd.secrets':
        owner => root,
        group => root,
        mode => '0600',
        content => "${secrets}\n",
        show_diff => false,
    }
}
