class profile::system::systemd {
    exec { 'systemd reload':
        command => '/usr/bin/systemctl daemon-reload',
        refreshonly => true,
    }
    Exec['systemd reload'] -> Service <| |>
}

class profile::system::systemd::journal {
    file { '/etc/systemd/journald.conf':
        ensure => file,
        source => 'puppet:///modules/profile/systemd/journald.conf',
        notify => Service['systemd-journald'],
    }

    # Since we don't use the file storage anymore, make sure the default path is cleaned
    file { '/var/log/journal':
        ensure => absent,
        owner => undef,
        group => undef,
        mode => undef,
        recurse => true,
        force => true,
    }

    service { 'systemd-journald':
        enable => true,
        ensure => running,
    }
}
