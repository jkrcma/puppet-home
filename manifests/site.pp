node default {
    include role::noop
}

node dns {
    include role::dns_server
}

node nas {
    include role::nas
}

node torrent {
    include role::torrent_box
}

node build {
    include role::build
}

node monitor {
    include role::monitor
}
