class role::docker_runner {
    include profile::base
    include profile::system::lxc
    include profile::docker
}
