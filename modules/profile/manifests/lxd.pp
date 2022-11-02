class profile::lxd (String $package_provider = undef) {
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

class profile::lxd::preseed (String $trust_password = undef, String $metrics_cert = undef) {
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

    exec { 'add metrics certificate':
        path => '/snap/bin:/usr/bin',
        command => "echo '${metrics_cert}' | lxc config trust add - --type=metrics",
        unless => 'lxc config trust list -f csv | grep -q "662769fcb37b"',
    }
}
