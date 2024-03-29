class profile::system::syslog::busybox {
    # make sure that rsyslog is completely removed
    package { 'rsyslog':
        ensure => purged,
        require => Service['rsyslog'],
    }
    service { 'rsyslog':
        enable => false,
        ensure => stopped,
    }

    # install and enable busybox-syslogd
    package { 'busybox-syslogd':
        ensure => latest,
        require => Package['rsyslog'],
        notify => Service['busybox-syslogd'],
    }
    service { 'busybox-syslogd':
        enable => true,
        ensure => running,
        require => File['default.syslogd']
    }
    file { 'default.syslogd':
        path => '/etc/default/busybox-syslogd',
        ensure => file,
        source => 'puppet:///modules/profile/syslog/default.syslogd',
        require => Package['rsyslog'],
        notify => Service['busybox-syslogd'],
    }
}

class profile::system::syslog::rsyslog (Boolean $promtail_relay = false) {
    package { 'rsyslog':
        ensure => latest,
    }
    service { 'rsyslog':
        enable => true,
        ensure => running,
    }

    file { '/etc/rsyslog.d/00-promtail.conf':
        ensure => file,
        source => 'puppet:///modules/profile/rsyslog/00-promtail.conf',
        notify => Service['rsyslog'],
    }
}
