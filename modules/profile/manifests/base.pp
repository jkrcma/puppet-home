class profile::base (String $syslog_provider = 'busybox') {
    include network
    include profile::system::puppet
    include profile::system::aliases
    include profile::system::logcheck
    include profile::system::packages
    include profile::system::security
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

    # disks.sda.model - RPi 4 with USB sticks
    # blockdevices - RPi 4 with SD cards
    if (has_key($facts['disks'], 'sda')
        and has_key($facts['disks']['sda'], 'model')
        and $facts['disks']['sda']['model'] =~ /^Flash/)
        or $facts['blockdevices'] =~ /mmcblk\d+/ {
        include profile::system::log2ram
    }

    include profile::account::taiku

    file {'/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/Europe/Prague',
    }
}
