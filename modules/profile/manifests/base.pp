class profile::base {
    include profile::syslog
    include profile::account::taiku

    # puppet everything-is-wrong-case binaries
    file {'/usr/local/bin/puppet-test':
        ensure => file,
        owner => root,
        group => root,
        mode => 4755,
        source => "puppet:///modules/profile/puppet/${::architecture}/puppet-test",
    }

    file {'/usr/local/bin/puppet-apply':
        ensure => file,
        owner => root,
        group => root,
        mode => 4755,
        source => "puppet:///modules/profile/puppet/${::architecture}/puppet-test",
    }
}
