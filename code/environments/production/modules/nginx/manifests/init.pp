class nginx {
    package { 'nginx-light':
        ensure => latest,
    }
    service { 'nginx':
        enable => true,
        ensure => running,
        require => Package['nginx-light'],
    }
}
