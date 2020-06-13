class role::pihole {
    include profile::base
    include profile::system::lxc
    include profile::pihole
}
