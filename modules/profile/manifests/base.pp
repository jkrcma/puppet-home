class profile::base {
    include network
    include profile::system::puppet
    include profile::system::logcheck
    include profile::system::packages
    include profile::system::syslog
    include profile::system::systemd
    include profile::system::cleanup
    include profile::prometheus::node_exporter
    include profile::promtail

    include profile::account::taiku

    file {'/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/Europe/Prague',
    }
}
