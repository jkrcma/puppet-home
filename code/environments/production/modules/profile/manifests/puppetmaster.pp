class profile::puppetmaster {
    package { 'puppetmaster':
        ensure => latest,
    }

    service { 'puppet-master':
        ensure => running,
        enable => true,
    }
}
