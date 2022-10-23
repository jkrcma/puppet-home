class profile::system::log2ram::apt {
    file { 'azlux.list':
        path => '/etc/apt/sources.list.d/azlux.list',
        ensure => file,
        content => "deb http://packages.azlux.fr/debian/ stable main\n",
        notify => Exec['apt-key add azlux.list'],
    }

    exec { 'apt-key add azlux.list':
        command => "/usr/bin/wget https://azlux.fr/repo.gpg -O - | /usr/bin/apt-key add -",
        refreshonly => true,
        notify => Exec['apt-get update forced'],
    }
}

class profile::system::log2ram {
    include profile::system::log2ram::apt

    package { 'log2ram':
        ensure => latest,
    }

    service { 'log2ram':
        enable => true,
        ensure => running,
        require => Package['log2ram'],
    }

    # Make sure that the journal storage is clean before starting the service
    File['/var/log/journal'] -> Service['log2ram']

    # No need to store logs on disk, we have Loki
    service { 'log2ram-daily.timer':
        enable => false,
        ensure => stopped,
        require => Package['log2ram'],
    }
}
