class profile::transmission($data_directory = undef, $web_directory = undef) {
    apt::ppa { 'transmissionbt':
        source => 'puppet:///modules/profile/transmission/sources.list',
        fingerprint => '365C5CA1',
    } ->
    # required order makes sure apt won't install the GUI
    package { 'transmission-daemon':
        ensure => latest,
    } ->
    package { 'transmission-cli':
        ensure => latest,
    } ->
    package { 'transmission':
        ensure => latest,
    } ->
    package { 'transmission-web-transmission-control':
        ensure => latest,
    }

    service { 'transmission-daemon':
        enable => true,
        ensure => running,
        hasrestart => true,
        restart => '/usr/bin/systemctl reload transmission-daemon',
        require => Package['transmission-daemon'],
    }

    file { '/etc/transmission-daemon':
        ensure => directory,
        owner => debian-transmission,
        group => debian-transmission,
        mode => '2775',
    }
    file { '/etc/transmission-daemon/settings.json':
        ensure => file,
        owner => debian-transmission,
        group => debian-transmission,
        mode => '0600',
        content => template('profile/transmission/settings.json.erb'),
        require => Package['transmission-daemon'],
        notify => Service['transmission-daemon'],
    }

    file { '/var/lib/transmission-daemon':
        ensure => directory,
        require => Package['transmission-daemon'],
    }

    # web UI override
    if $web_directory {
        file { '/etc/systemd/system/transmission-daemon.service':
            ensure => file,
            content => template('profile/transmission/transmission-daemon.service.erb'),
        }
    }

    # file cache warmer cron
    if $data_directory {
        file { '/usr/local/bin/transmission-cache-warmer.sh':
          ensure => file,
          mode  => '0755',
          source => 'puppet:///modules/profile/transmission/transmission-cache-warmer.sh',
        }

        cron { 'file cache warmer':
          environment => 'SHELL=/bin/sh',
          command => "#/usr/local/bin/transmission-cache-warmer.sh ${data_directory}",
          user => debian-transmission,
          minute => '*/5',
        }
    }

    include nginx
    nginx::virtualhost { 'default':
        source => 'puppet:///modules/profile/transmission/default.nginx',
    }
}
