class profile::system::puppet {
    service { 'puppet':
        ensure => running,
        enable => true,
    }
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

    # Don't deploy on masters, these are managed by Ansible
    if $group != 'puppet' {
        file {'/etc/puppet/puppet.conf':
            ensure => file,
            source => 'puppet:///modules/profile/puppet/puppet.conf',
            notify => Service['puppet'],
        }
    }
}
