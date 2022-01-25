class profile::lxd ($package_provider = undef) {
    include profile::lxd::preseed

    if $package_provider == 'snap' {
        include ::snapd
    } else {
        fail("The only supported package provider for LXD is 'snap'.")
    }

    package { 'lxd':
        ensure => latest,
        provider => $package_provider,
    }

    file { ['/data', '/data/lxd']:
        ensure => directory,
    }
}

class profile::lxd::preseed ($trust_password = undef) {
    $preseed_file = '/data/lxd-preseed.yml'
    file { $preseed_file:
        ensure => file,
        mode => '0400',
        content => template('profile/lxd/lxd-init.yml.erb'),
    }

    exec { 'lxd init with preseed':
        path => '/snap/bin:/usr/bin',
        command => "cat ${preseed_file} | lxd init --preseed",
        require => File[$preseed_file],
        creates => '/var/snap/lxd/common/state',
    }
}
