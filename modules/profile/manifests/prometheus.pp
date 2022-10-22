class profile::prometheus::common {
    file { '/etc/prometheus':
        ensure => directory,
        source => 'puppet:///modules/profile/prometheus',
    }
}

class profile::prometheus::server ($external_url = undef) {
    include profile::prometheus::common

    package { 'prometheus':
        ensure => latest,
    }

    service { 'prometheus':
        enable => true,
        ensure => running,
        require => Package['prometheus'],
    }

    file { '/etc/prometheus/prometheus.yml':
        ensure => file,
        group => prometheus,
        mode => '0640',
        source => 'puppet:///modules/profile/prometheus/prometheus.yml',
        notify => Service['prometheus'],
    }

    file { '/etc/prometheus/alerts':
        ensure  => directory,
        recurse => true,
        purge   => true,
        source  => 'puppet:///modules/profile/prometheus/alerts',
        notify => Service['prometheus'],
    }

    file { '/etc/systemd/system/prometheus.service':
        ensure => file,
        content => template('profile/prometheus/prometheus.service.erb'),
        notify => Service['prometheus'],
    }
}

class profile::prometheus::alertmanager ($external_url = undef) {
    include profile::prometheus::common

    package { 'alertmanager':
        ensure => latest,
    }

    service { 'alertmanager':
        enable => true,
        ensure => running,
        require => Package['alertmanager'],
    }

    file { '/etc/prometheus/alertmanager.yml':
        ensure => file,
        group => prometheus,
        mode => '0640',
        source => 'puppet:///modules/profile/prometheus/alertmanager.yml',
        validate_cmd => '/usr/bin/amtool check-config %',
        notify => Service['alertmanager'],
    }

    file { '/etc/systemd/system/alertmanager.service':
        ensure => file,
        content => template('profile/prometheus/alertmanager.service.erb'),
        notify => Service['alertmanager'],
    }
}

class profile::prometheus::blackbox_exporter {
    include profile::prometheus::common

    package { 'blackbox-exporter':
        ensure => latest,
    }

    service { 'blackbox-exporter':
        enable => true,
        ensure => running,
        require => Package['blackbox-exporter'],
    }

    file { '/etc/prometheus/blackbox.yml':
        ensure => file,
        group => prometheus,
        mode => '0640',
        source => 'puppet:///modules/profile/prometheus/blackbox.yml',
        notify => Service['blackbox-exporter'],
    }
}

class profile::prometheus::snmp_exporter {
    include profile::prometheus::common

    package { 'snmp-exporter':
        ensure => latest,
    }

    service { 'snmp-exporter':
        enable => true,
        ensure => running,
        require => Package['snmp-exporter'],
    }

    file { '/etc/prometheus/snmp.yml':
        ensure => file,
        group => prometheus,
        mode => '0640',
        source => 'puppet:///modules/profile/prometheus/snmp.yml',
        notify => Service['snmp-exporter'],
    }
}

class profile::prometheus::node_exporter ($version = undef, $extraArgs = '') {
    # New Ubuntu has their own node-exporter in the way,
    # make sure we don't use it.
    package { 'prometheus-node-exporter':
        ensure => absent,
    }

    service { 'prometheus-node-exporter':
        enable => false,
        ensure => stopped,
        before => Package['prometheus-node-exporter'],
    }

    package { 'node-exporter':
        ensure => $version ? {
            undef => latest,
            default => $version,
        },
    }

    service { 'node-exporter':
        enable => true,
        ensure => running,
        require => Package['node-exporter'],
    }

    $args = $version ? {
        /^1\.2/ => '--log.level warn --collector.textfile.directory /etc/node-exporter',
        /^1\.4/ => '--log.level warn --collector.textfile.directory /etc/node-exporter/**',
        default => undef,
    }

    if ! $version {
        fail("No node_exporter version provided")
    }

    file { '/etc/default/node-exporter':
        ensure => file,
        content => "OPTIONS=\"${args} ${extraArgs}\"\n",
        notify => Service['node-exporter'],
    }

    file { ['/etc/node-exporter', '/etc/node-exporter/crons']:
        ensure => directory,
    }

    file { '/etc/node-exporter/crons/puppet.prom':
        ensure => file,
        group => puppet,
    }

    exec { 'puppet run metric':
        command => '/usr/bin/printf "# TYPE puppet_last_run gauge\npuppet_last_run %.9e\n" $( date +%s ) > /etc/node-exporter/crons/puppet.prom',
        loglevel => debug,
    }
}
