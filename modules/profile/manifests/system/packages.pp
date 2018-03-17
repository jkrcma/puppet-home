class profile::system::packages ($gpg_key) {
    stage { 'apt':
        before => Stage['main']
    }

    file { 'den.list':
        path => '/etc/apt/sources.list.d/den.list',
        ensure => file,
        content => "deb http://build.den xenial/\n",
        notify => Exec['apt-key add'],
    }

    exec { 'apt-key add':
        command => "/bin/echo \"$gpg_key\" | /usr/bin/apt-key add -",
        refreshonly => true,
    }

    class { profile::system::packages::apt: stage => 'apt' }

    package { ['openssh-server', 'httpie']:
        ensure => latest,
    }
}

class profile::system::packages::apt {
    exec { 'apt-get update':
        command => "/usr/bin/apt-get update",
        onlyif => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1 | tail -1 )) )) <= 604800 ))'"
    }
}
