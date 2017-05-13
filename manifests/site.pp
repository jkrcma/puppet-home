node default {
    include role::noop
}

node dns {
    include role::dns_server
}
