class profile::system::packages {
    stage { 'apt':
        before => Stage['main']
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
