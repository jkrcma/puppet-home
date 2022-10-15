define network::ifupdown::dev(Hash[String, Data] $bridgeport = {}, $options = undef) {
    $path = $network::ifupdown::path
    $interface = $name
    if $bridgeport['port'] {
        $bridgeport_def = {'dhcp' => false}
        $bridgeport_merged = $bridgeport_def + $bridgeport
        $erb_name = 'dev-br'
    } else {
        $erb_name = 'dev'
    }

    file { "${path}/${name}":
        ensure => file,
        content => template("network/ifupdown/${erb_name}.erb"),
        notify => Exec["ifup ${name}"],
    }

    exec { "ifup ${name}":
        command => "ifup ${name}",
        path => '/usr/sbin:/sbin',
        unless => "ifquery --state ${name} >/dev/null",
    }
}
