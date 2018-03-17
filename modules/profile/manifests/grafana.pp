class profile::grafana::apt {
    file { 'grafana.list':
        path => '/etc/apt/sources.list.d/grafana.list',
        ensure => file,
        content => "deb https://packagecloud.io/grafana/stable/debian/ jessie main\n",
        notify => Exec['apt-key add grafana.list'],
    }

    exec { 'apt-key add grafana.list':
        command => "/usr/bin/wget https://packagecloud.io/gpg.key -O - | /usr/bin/apt-key add -",
        refreshonly => true,
    }
}

class profile::grafana {
    include profile::grafana::apt

    package { 'grafana':
        ensure => latest,
    }

    service { 'grafana-server':
        enable  => true,
        ensure  => running,
        require => Package['grafana'],
    }

    file { '/etc/grafana/grafana.ini':
        ensure => file,
        group => grafana,
        mode => '640',
        source => 'puppet:///modules/profile/grafana/grafana.ini',
        require => Package['grafana'],
        notify => Service['grafana-server'],
    }

    include nginx
    nginx::virtualhost { 'default':
        source => 'puppet:///modules/profile/grafana/default.nginx',
    }
}
