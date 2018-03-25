class role::dns_server {
    include profile::base
    include profile::system::lxc
    include profile::bind9
}
