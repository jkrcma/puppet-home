define apt::ppa($source, $fingerprint) {
    file { "/etc/apt/sources.list.d/$name.list":
        ensure => file,
        source => $source,
        notify => Exec['apt-key-adv']
    }

    exec { 'apt-key-adv':
        command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $fingerprint",
        refreshonly => true,
        notify => Exec['ppa-apt-update'],
    }

    exec { 'ppa-apt-update':
        command => "/usr/bin/apt update",
        refreshonly => true,
    }
}
