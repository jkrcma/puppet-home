class role::lxd_host {
    include profile::base
    include profile::lxd
    include profile::backup::rsyncd
}
