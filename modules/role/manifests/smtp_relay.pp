class role::smtp_relay {
    include profile::base
    include profile::system::lxc
    include profile::postfix
}
