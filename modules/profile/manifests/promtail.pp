class profile::promtail (Boolean $journald = true) {
    package { 'promtail':
        ensure => latest,
    }

    service { 'promtail':
        enable => true,
        ensure => running,
        require => Package['promtail'],
    }

    @user { 'promtail':
        groups => ['promtail'],
        membership => minimum,
    }

    if $journald {
        Package['promtail'] ->
        User <| title == promtail |> { groups +> 'systemd-journal' }
    }

    file { '/etc/promtail/promtail.yml':
        ensure => file,
        group => promtail,
        source => 'puppet:///modules/profile/promtail/promtail.yml',
        require => Package['promtail'],
        notify => Service['promtail'],
    }
}
