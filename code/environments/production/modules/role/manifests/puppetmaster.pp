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
    include profile::keepalived::puppetmaster
}

class role::puppetmaster::secondary {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster::secondary
    include profile::keepalived
    include profile::keepalived::puppetmaster
}
