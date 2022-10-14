class profile::keepalived (String $state, Integer $priority, String $password, String $smtp_host) {
    package { 'keepalived':
        ensure => latest,
    }

    service { 'keepalived':
        enable => true,
        ensure => running,
        require => Package['keepalived'],
    }

    file { '/etc/keepalived/conf.d':
        ensure => directory,
        require => Package['keepalived'],
    }

    # Main configuration - per group
    file { '/etc/keepalived/keepalived.conf':
        ensure => file,
        content => template("profile/keepalived/${group}.conf.erb"),
        require => Package['keepalived'],
        notify => Service['keepalived'],
    }

    # Config snippets
    $snippets = ['global_defs']
    $snippets.map |String $snippet| {
        file { "/etc/keepalived/conf.d/${snippet}.conf":
            ensure => file,
            content => template("profile/keepalived/conf.d/${snippet}.conf.erb"),
            require => Package['keepalived'],
        }
    }
}
