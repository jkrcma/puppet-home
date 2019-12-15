class profile::samba {
    package { 'samba':
        ensure => latest,
    }

    service { 'smbd':
        enable => true,
        ensure => running,
        require => Package['samba'],
    }
    service { 'nmbd':
        enable => true,
        ensure => running,
        require => Package['samba'],
    }

    file { '/etc/samba':
        ensure => directory,
    }
    file { '/etc/samba/smb.conf':
        ensure => file,
        source => 'puppet:///modules/profile/samba/smb.conf',
        notify => Service[['smbd', 'nmbd']],
    }

    # fixes log changing during gzipping bug
    file { '/etc/logrotate.d/samba':
        ensure => file,
        source => 'puppet:///modules/profile/samba/samba.logrotate',
    }

    # causes useless reloads at every DHCP re-lease
    file { '/etc/dhcp/dhclient-enter-hooks.d/samba':
        ensure => absent,
    }
}
