class role::puppetmaster {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster
}

class role::puppetmaster::primary {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster::primary
    include profile::keepalived
}

class role::puppetmaster::secondary {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster::secondary
    include profile::keepalived
}
