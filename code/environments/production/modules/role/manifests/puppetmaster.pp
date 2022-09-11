class role::puppetmaster {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster
}

class role::puppetmaster::primary {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster::primary
}

class role::puppetmaster::secondary {
    include profile::base
    include profile::system::lxc
    include profile::puppetmaster::secondary
}
