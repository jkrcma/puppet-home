class profile::pihole ($webpassword = undef) {
    package { 'wget':
        ensure => latest,
    }
    # blackbox exec, whatever :)
    exec { 'pihole-automated-install':
        command => 'wget -O /root/pihole-install.sh https://install.pi-hole.net && bash /root/pihole-install.sh --unattended',
        path => ['/usr/bin'],
        creates => '/usr/local/bin/pihole',
        require => Package['wget'],
    }

    service { 'pihole-FTL':
        enable => true,
        ensure => running,
        require => Exec['pihole-automated-install'],
    }

    file { '/etc/pihole':
        ensure => directory,
    }

    file { '/etc/pihole/setupVars.conf':
        ensure => file,
        owner => root,
        group => root,
        mode => '0644', # FIXME?
        content => template('profile/pihole/setupVars.conf.erb'),
        before => Exec['pihole-automated-install'],
    }

    file { '/etc/dnsmasq.d/02-no-hosts.conf':
        ensure => file,
        content => "no-hosts\n",
        require => Exec['pihole-automated-install'],
        notify => Service['pihole-FTL'],
    }

}

class profile::pihole::exporter {
    package { 'pihole-exporter':
        ensure => latest,
    }

    service { 'pihole-exporter':
        enable => true,
        ensure => running,
        require => Package['pihole-exporter'],
    }

    file { '/etc/default/pihole-exporter':
        ensure => file,
        content => template('profile/pihole/pihole-exporter.default.erb'),
        notify => Service['pihole-exporter'],
    }
}
