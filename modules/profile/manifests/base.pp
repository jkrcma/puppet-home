class profile::base {
    include profile::system::logcheck
    include profile::system::packages
    include profile::system::syslog
    include profile::prometheus::node_exporter

    include profile::account::taiku

    # puppet everything-is-wrong-case binaries
    file {'/usr/local/bin/puppet-test':
        ensure => file,
        owner => root,
        group => root,
        mode => '4755',
        source => "puppet:///modules/profile/puppet/${::architecture}/puppet-test",
    }

    file {'/usr/local/bin/puppet-apply':
        ensure => file,
        owner => root,
        group => root,
        mode => '4755',
        source => "puppet:///modules/profile/puppet/${::architecture}/puppet-apply",
    }

    file {'/etc/puppet/puppet.conf':
        ensure => file,
        links => follow,
        source => 'puppet:///modules/profile/puppet/puppet.conf',
    }

    file {'/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/Europe/Prague',
    }
}
