node default {
    include role::noop
}

node puppet {
    include role::puppetmaster
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

node mediabox {
    include role::media_box
}

node kodi {
    include role::kodi
}

node smtp {
    include role::smtp_relay
}
