class profile::pihole {
    include profile::pihole::config
    include profile::pihole::dns_override

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

    exec { 'pihole-reconfigure':
        command => 'bash /root/pihole-install.sh --reconfigure --unattended',
        path => ['/bin'],
        refreshonly => true,
    }

    service { 'pihole-FTL':
        enable => true,
        ensure => running,
        require => Exec['pihole-automated-install'],
    }
}

class profile::pihole::config (String $webpassword = undef, String $exclude_domains = undef) {
    File['/etc/pihole/gravity-update.sh']
    -> exec { 'pihole-update-adlist':
        command => '/etc/pihole/gravity-update.sh',
        path => ['/usr/local/bin', '/bin'],
        refreshonly => true,
    }

    exec { 'pihole-blacklist':
        command => 'cat /etc/pihole/blacklist.list | xargs pihole -b',
        path => ['/usr/local/bin', '/usr/bin'],
        refreshonly => true,
    }

    exec { 'pihole-whitelist':
        command => 'cat /etc/pihole/whitelist.list | xargs pihole -w',
        path => ['/usr/local/bin', '/usr/bin'],
        refreshonly => true,
    }

    file { '/etc/pihole':
        ensure => directory,
    }

    # Pi-Hole being broken is the reason why this file must exist
    file { '/etc/pihole/pihole-FTL.conf':
        ensure => file,
        content => "PIHOLE_PTR=false\nPRIVACYLEVEL=0\n",
        before => Exec['pihole-automated-install'],
        notify => Exec['pihole-reconfigure'],
    }

    file { '/etc/pihole/setupVars.conf':
        ensure => file,
        owner => root,
        group => root,
        mode => '0644',
        content => template('profile/pihole/setupVars.conf.erb'),
        before => Exec['pihole-automated-install'],
        notify => Exec['pihole-reconfigure'],
    }

    file { '/etc/dnsmasq.d/02-no-hosts.conf':
        ensure => file,
        content => "no-hosts\n",
        require => Exec['pihole-automated-install'],
        notify => Service['pihole-FTL'],
    }

    file { '/etc/pihole/gravity-update.sh':
        ensure => file,
        mode => '0755',
        source => 'puppet:///modules/profile/pihole/gravity-update.sh',
    }

    file { '/etc/pihole/adlists.list':
        ensure => file,
        source => 'puppet:///modules/profile/pihole/adlists.list',
        notify => Exec['pihole-update-adlist'],
    }

    file { '/etc/pihole/blacklist.list':
        ensure => file,
        source => 'puppet:///modules/profile/pihole/blacklist.list',
        notify => Exec['pihole-blacklist'],
    }

    file { '/etc/pihole/whitelist.list':
        ensure => file,
        source => 'puppet:///modules/profile/pihole/whitelist.list',
        notify => Exec['pihole-whitelist'],
    }
}

class profile::pihole::dns_override {
    host { 'puppet5.den':
        ip => '10.7.21.25',
        comment => "DNS master treats Pi-Hole as a user VLAN client, resolving into a different IP."
    }
    host { 'smtp.den':
        ip => '10.7.21.17',
        comment => "These services wouldn't work for this container at all."
    }
    host { 'build.den':
        ip => '10.7.21.21',
        comment => "Needed for the apt repository.",
    }
}

class profile::pihole::exporter {
    include profile::pihole::config
    $webpassword = $profile::pihole::config::webpassword

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
