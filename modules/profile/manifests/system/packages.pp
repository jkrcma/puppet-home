class profile::system::packages ($gpg_key, $enable_exim4 = true) {
    if ($enable_exim4) {
        include profile::system::packages::exim4
    }

    stage { 'apt':
        before => Stage['main']
    }

    exec { 'apt-get update forced':
        command => "/usr/bin/apt-get update",
        refreshonly => true,
    }

    file { 'den.list':
        path => '/etc/apt/sources.list.d/den.list',
        ensure => file,
        content => "deb http://build.den ${facts['lsbdistcodename']}/\n",
        notify => Exec['apt-key add den.list'],
    }

    exec { 'apt-key add den.list':
        command => "/bin/echo \"$gpg_key\" | /usr/bin/apt-key add -",
        refreshonly => true,
        require => Package['gnupg'],
        notify => Exec['apt-get update forced'],
    }

    class { profile::system::packages::apt: stage => 'apt' }

    package { ['openssh-server', 'httpie', 'gnupg', 'cron', 'fping']:
        ensure => latest,
    }

    service { 'ssh':
        enable => true,
        ensure => running,
        require => Package['openssh-server'],
    }

    exec { 'disable motd-news timer':
        command => "/bin/systemctl disable motd-news.service motd-news.timer",
        onlyif => "/bin/systemctl cat motd-news.timer >/dev/null && /bin/systemctl is-enabled motd-news.timer >/dev/null",
    }
}

class profile::system::packages::apt {
    exec { 'apt-get update':
        command => "/usr/bin/apt-get update",
        onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1 | tail -1 )) )) <= 86400 ))'",
        loglevel => debug,
    }
}

class profile::system::packages::exim4 {
    package { 'exim4-daemon-light':
        ensure => latest,
    }

    service { 'exim4':
        enable => true,
        ensure => running,
        require => Package['exim4-daemon-light'],
    }

    file { '/etc/exim4/update-exim4.conf.conf':
        ensure => file,
        content => template('profile/packages/update-exim4.conf.conf.erb'),
        require => Package['exim4-daemon-light'],
        notify => Exec['exim4 config update'],
    }

    file { '/etc/exim4/exim4.conf.localmacros':
        ensure => file,
        source => 'puppet:///modules/profile/packages/exim4.conf.localmacros',
        require => Package['exim4-daemon-light'],
        notify => Exec['exim4 config update'],
    }

    exec { 'exim4 config update':
        command => '/usr/sbin/update-exim4.conf',
        refreshonly => true,
        notify => Service['exim4'],
    }

    $textfile_ensure = $::node_exporter_textfile_dir ? {
        '1' => present,
        default => absent,
    }

    file { '/etc/node-exporter/exim4.prom':
        ensure => $textfile_ensure,
        owner => 'Debian-exim',
    }

    cron { 'local maildir size':
        ensure => $textfile_ensure,
        environment => 'SHELL=/bin/sh',
        command => '/usr/bin/printf "# TYPE exim4_local_maildir_size gauge\nexim4_local_maildir_size \%d\n" $( /usr/bin/stat --printf="\%s" /var/mail/mail ) > /etc/node-exporter/exim4.prom',
        user => 'Debian-exim',
        minute => '*/5',
    }
}
