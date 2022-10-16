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

    service { 'systemd-journald':
        enable => true,
        ensure => running,
    }
}
