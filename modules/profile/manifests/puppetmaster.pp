class profile::puppetmaster {
    include profile::puppetmaster::config

    $homedir = $profile::puppetmaster::config::homedir

    package { ['puppet-master', 'hiera-eyaml', 'git', 'rsync']:
        ensure => latest,
    }

    service { 'puppet-master':
        ensure => running,
        enable => true,
    }

    # Enable shell so the CA rsync can work
    user { 'puppet':
        ensure => present,
        shell => '/bin/sh',
        require => Package['puppet-master'],
    }

    # eyaml keys are in Ansible because of circular dependency
    file { "${homedir}/keys/private_key.pkcs7.pem":
        ensure => file,
        owner => puppet,
        group => puppet,
        mode => '0600',
        noop => true,
        require => Package['puppet-master'],
    }
    file { "${homedir}/keys/public_key.pkcs7.pem":
        ensure => file,
        owner => puppet,
        group => puppet,
        mode => '0600',
        noop => true,
        require => Package['puppet-master'],
    }
}

class profile::puppetmaster::primary {
    include profile::puppetmaster
    include profile::puppetmaster::config

    $homedir = $profile::puppetmaster::config::homedir
    $sync_dest_host = $profile::puppetmaster::config::sync_dest_host

    file { "${homedir}/.ssh":
        ensure => directory,
        owner => puppet,
        group => puppet,
        mode => '0700',
        require => Package['puppet-master'],
    }

    # SSH key is in Ansible, we don't want it to be dependent on eyaml
    ['id_ed25519', 'id_ed25519.pub'].each |$file| {
        file { "${homedir}/.ssh/${file}":
            ensure => file,
            owner => puppet,
            group => puppet,
            mode => '0600',
            noop => true,
            require => Package['puppet-master'],
        }
    }

    $known_hosts_file = "${homedir}/.ssh/known_hosts"
    exec { 'scan sync destination host key':
        command => "/usr/bin/ssh-keyscan ${sync_dest_host} > ${known_hosts_file}",
        creates => $known_hosts_file,
        user => puppet,
        require => Package['puppet-master'],
    }

    $cadir = "${homedir}/ssl/ca"
    cron { 'puppet CA sync':
        command => "/usr/bin/rsync -aq ${cadir}/ puppet@${sync_dest_host}:${cadir}",
        user => puppet,
        minute => '*/5',
        require => Package['puppet-master'],
    }
}

class profile::puppetmaster::secondary {
    include profile::puppetmaster
    include profile::puppetmaster::config

    $homedir = $profile::puppetmaster::config::homedir
    $sshkey_type = $profile::puppetmaster::config::sync_sshkey_type
    $sshkey = $profile::puppetmaster::config::sync_sshkey

    ssh_authorized_key { "primary@puppetmaster":
        ensure => present,
        user => puppet,
        type => $sshkey_type,
        key => $sshkey,
    }
}

class profile::puppetmaster::config ($homedir = '/var/lib/puppet', $sync_sshkey_type = undef, $sync_sshkey = undef, $sync_dest_host = undef) {
    # Dummy config class, might be used later for `puppet.conf`
}
