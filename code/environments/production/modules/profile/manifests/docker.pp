class profile::docker (String $auths = "") {
    package { 'docker.io':
        ensure => latest,
    }

    service { 'docker':
        enable => true,
        ensure => running,
        require => Package['docker.io'],
    }

    file { '/root/.docker':
        ensure => directory,
    }
    file { '/root/.docker/config.json':
        ensure => file,
        content => template('profile/docker/config.json.erb'),
        require => Package['docker.io'],
        notify => Service['docker'],
    }
}
