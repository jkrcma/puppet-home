class profile::lxd ($package_provider = undef) {
    if $package_provider == 'snap' {
        include ::snapd
    }

    package { 'lxd':
        ensure => latest,
        provider => $package_provider,
    }
}
