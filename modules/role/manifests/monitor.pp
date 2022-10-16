class role::monitor {
    include profile::base
    include profile::system::lxc
    include profile::prometheus::server
    include profile::prometheus::alertmanager
    include profile::prometheus::blackbox_exporter
    include profile::prometheus::snmp_exporter
    include profile::promtail
    include profile::loki
    include profile::grafana
}
