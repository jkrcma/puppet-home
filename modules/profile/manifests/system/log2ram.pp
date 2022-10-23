class profile::log2ram::apt {
    file { 'azlux.list':
        path => '/etc/apt/sources.list.d/azlux.list',
        ensure => file,
        content => "deb http://packages.azlux.fr/debian/ stable main\n",
        notify => Exec['apt-key add azlux.list'],
    }

    exec { 'apt-key add azlux.list':
        command => "/usr/bin/wget https://azlux.fr/repo.gpg -O - | /usr/bin/apt-key add -",
        refreshonly => true,
    }
}

class profile::log2ram {
    include profile::log2ram::apt

    package { 'log2ram':
        ensure => latest,
    }

    service { 'log2ram':
        enable => true,
        ensure => running,
        require => Package['log2ram'],
    }

    # No need to store logs on disk, we have Loki
    service { 'log2ram-daily.timer':
        enable => false,
        ensure => stopped,
        require => Package['log2ram'],
    }
