class profile::kubernetes {
    include k3s::install

    # node tag for ZigBee gateway
    # TODO: this might not work for worker nodes in the future
    exec { 'set label for ZigBee':
        command => "kubectl label nodes ${facts['hostname']} home.taiku.cz/hardware=zigbee-controller",
        path => '/usr/local/bin:/usr/bin:/bin',
        unless => "kubectl label nodes ${facts['hostname']} --list | grep ^home.taiku.cz/hardware=zigbee-controller",
        onlyif => 'lsusb -d 1cf1:0030',

    }

    # hacky way to reduce the verbosity of k3s logs
    file_line { 'k3s log level':
        ensure => present,
        path => '/etc/systemd/system/k3s.service',
        line => 'LogLevelMax=3',
        after => '^LimitCORE=',
    }

    # Debian/Ubuntu iptables bug workaround
    # https://github.com/k3s-io/k3s/issues/3117
    package { ['iptables', 'nftables']:
        ensure => absent,
    }

    # Blacklist VLAN 30 nameservers, we get them from VLAN 21
    file { '/etc/resolvconf.conf':
        ensure => file,
        source => 'puppet:///modules/profile/kubernetes/resolvconf.conf',
    }
}
