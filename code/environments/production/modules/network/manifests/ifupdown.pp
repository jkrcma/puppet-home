class network::ifupdown (Array[String] $interfaces, Hash $options = {}, String $path = '/etc/network/interfaces.d') {
    file { '/etc/network/interfaces':
        ensure => file,
        source => 'puppet:///modules/network/ifupdown/interfaces',
    }

    file { $path:
        ensure => directory,
        require => File['/etc/network/interfaces'],
    }

    file { "${path}/lo":
        ensure => file,
        content => "auto lo\niface lo inet loopback\n",
    }

    $interfaces.each |String $interface| {
        network::ifupdown::dev { $interface: options => $options[$interface] }
    }

    tidy { 'cleanup interfaces.d':
        path => $path,
        recurse => true,
    }

    service { 'dhcpcd':
        ensure => stopped,
        enable => false,
        require => Package['dhcpcd5'],
    }

    package { 'dhcpcd5':
        ensure => purged,
    }
}

class network::ifupdown::vlan (Optional[Array[String]] $interfaces = undef, Optional[Hash[String, Hash]] $bridges = undef) {
    if $bridges {
        $bridges.keys.each |String $interface| {
            network::ifupdown::dev { $interface: bridgeport => $bridges[$interface] }
        }
    }
    if $interfaces {
        $interfaces.each |String $interface| {
            network::ifupdown::dev { $interface: }
        }
    }
}
