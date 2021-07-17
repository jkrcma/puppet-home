class k3s::install (String $cluster_token, String $arguments = '') {
    package { 'curl':
        ensure => latest,
    }

    exec { 'install by sudo bash':
        command => 'curl -sfL https://get.k3s.io | sh -',
        path => '/usr/bin',
        environment => ["INSTALL_K3S_EXEC=${arguments}", "K3S_TOKEN=${cluster_token}"],
        creates => '/usr/local/bin/k3s',
        require => Package['curl'],
    }
}
