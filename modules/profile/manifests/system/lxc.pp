class profile::system::lxc {
    file { '/etc/cron.weekly/fstrim':
        ensure => absent,
    }
}

