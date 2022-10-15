class network::netplan (Optional[Array[String]] $interfaces = undef, String $kind = 'lxc') {
    if ($interfaces) {
        $all_interfaces = $interfaces
    } else {
        $all_interfaces = split($::facts['interfaces'], ',')
    }

    $target_interfaces = $all_interfaces - ['lo']
    $path = $kind ? {
        'lxc' => '10-lxc.yaml',
        default => fail("Unknown kind ${kind} for ${name}"),
    }

    file { "/etc/netplan/${path}":
        ensure => present,
        content => template('network/netplan/lxc.yaml.erb'),
        backup => '.puppet-bak',
        notify => Exec['try netplan'],
    }

    file { '/etc/netplan/try_config.sh':
        source => 'puppet:///modules/network/netplan/try_config.sh',
        mode => '0755',
    }

    $ips = $target_interfaces.map |String $interface| { $::facts["ipaddress_${interface}"] }.join(' ')
    exec { 'try netplan':
        command => "/etc/netplan/try_config.sh ${ips}",
        refreshonly => true,
        require => File['/etc/netplan/try_config.sh'],
    }
}
