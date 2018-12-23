class profile::postfix($dkim_domain_key = undef) {
    # install postfix, DKIM packages and enable the service
    package { 'postfix':
        ensure => latest,
    }
    package { ['opendkim', 'opendkim-tools']:
        ensure => latest,
    }
    service { 'postfix':
        enable => true,
        ensure => running,
        require => Package['postfix'],
    }
    service { 'opendkim':
        enable => true,
        ensure => running,
        require => Package['opendkim'],
    }

    # ensure config files
    file { '/etc/postfix':
        ensure => directory,
    }
    file { '/etc/postfix/main.cf':
        ensure => file,
        source => 'puppet:///modules/profile/postfix/main.cf',
        require => Package['postfix'],
        notify => Service['postfix'],
    }

    file { '/etc/opendkim':
        ensure => directory,
        owner => opendkim,
        group => opendkim,
        require => Package['opendkim'],
    }
    file { '/etc/opendkim.conf':
        ensure => file,
        group => opendkim,
        mode => '640',
        source => 'puppet:///modules/profile/postfix/opendkim/opendkim.conf',
        require => Package['opendkim'],
        notify => Service['opendkim'],
    }
    file { '/etc/opendkim/home.taiku.cz.key':
        ensure => file,
        owner => opendkim,
        group => opendkim,
        mode => '640',
        content => $dkim_domain_key,
        require => Package['opendkim'],
        notify => Service['opendkim'],
    }
    file { '/etc/opendkim/trusted.hosts':
        ensure => file,
        source => 'puppet:///modules/profile/postfix/opendkim/trusted.hosts',
        require => Package['opendkim'],
        notify => Service['opendkim'],
    }
    file { '/etc/default/opendkim':
        ensure => file,
        content => "SOCKET=\"inet:12301:localhost\"\n",
        require => Package['opendkim'],
        notify => Service['opendkim'],
    }
}
