class role::build {
    include profile::base
    include profile::system::lxc
    include profile::build
    include profile::dpkg_repo
}
