# Bare metal
node puppet5 {
    include role::puppetmaster
}

node /rpi-k8s-[0-9]+/ {}

# LXC containers
node puppet {}

node dns {
    include role::dns_server
}

node nas {
    include role::nas
}

node torrent {
    include role::torrent_box
}

node build {}

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

node pihole {
    include role::pihole
}

# Defaults
node default {
    include role::noop
}
