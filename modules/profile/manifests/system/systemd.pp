class profile::system::systemd {
    exec { 'systemd reload':
        command => '/usr/bin/systemctl daemon-reload',
        refreshonly => true,
    }
    Exec['systemd reload'] -> Service <| |>
}
