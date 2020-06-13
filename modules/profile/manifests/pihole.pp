class profile::pihole ($webpassword = undef) {
    # blackbox exec, whatever :)
    exec { 'pihole-automated-install':
        command => 'wget -O /root/pihole-install.sh https://install.pi-hole.net && bash root/pihole-install.sh',
        path => ['/usr/bin'],
        unless => 'test -x /usr/local/bin/pihole',
    }

    package { 'pihole-exporter':
        ensure => latest,
    }

    service { 'pihole-exporter':
        enable => true,
        ensure => running,
        require => Package['pihole-exporter'],
    }

    file { '/etc/pihole/setupVars.conf':
        ensure => file,
        owner => root,
        group => root,
        mode => '0644', # FIXME?
        content => template('profile/pihole/setupVars.conf.erb'),
        require => Exec['pihole-automated-install'],
    }

    file { '/etc/default/pihole-exporter':
        ensure => file,
        content => template('profile/pihole/pihole-exporter.default.erb'),
        notify => Service['pihole-exporter'],
    }
}
