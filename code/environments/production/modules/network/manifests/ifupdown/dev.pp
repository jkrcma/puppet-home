define network::ifupdown::dev() {
    $path = $network::ifupdown::path
    $interface = $name

    file { "${path}/${name}":
        ensure => file,
        content => template('network/ifupdown/dev.erb'),
        notify => Exec["ifup ${name}"],
    }

    exec { "ifup ${name}":
        command => "ifup ${name}",
        path => '/usr/sbin:/sbin',
        unless => "ifquery --state ${name} >/dev/null",
    }
}
