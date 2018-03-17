class profile::build {
    package { 'debhelper':
        ensure => latest,
    }
}
