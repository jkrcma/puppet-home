class profile::puppetmaster {
    package { ['puppetmaster', 'hiera-eyaml', 'git']:
        ensure => latest,
    }

    service { 'puppet-master':
        ensure => running,
        enable => true,
    }

    exec { 'create eyaml keys':
        command => 'eyaml createkeys && chown -R puppet:puppet keys/',
        path => '/usr/bin',
        cwd => '/var/lib/puppet',
        creates => '/var/lib/puppet/keys',
    }
}
