class profile::base (String $syslog_provider = 'busybox') {
    include network
    include profile::system::puppet
    include profile::system::logcheck
    include profile::system::packages
    include profile::system::systemd
    include profile::system::cleanup
    include profile::prometheus::node_exporter

    # Centreal logging
    case $syslog_provider {
        'busybox': {
            include profile::system::syslog::busybox
        }
        'rsyslog': {
            include profile::system::syslog::rsyslog
        }
        default: {
            fail("Unknown syslog provider selected: ${syslog_provider}")
        }
    }
    include profile::system::systemd::journal

    include profile::account::taiku

    file {'/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/Europe/Prague',
    }
}
