class profile::kubernetes {
    include k3s::install

    # node tag for ZigBee gateway
    # TODO: this might not work for worker nodes in the future
    exec { 'set label for ZigBee'
        command => 'kubectl label nodes ${facts['hostname']} home.taiku.cz/hardware=zigbee',
        path => '/usr/local/bin:/usr/bin:/bin',
        unless => "kubectl label nodes ${facts['hostname']} --list | grep ^home.taiku.cz/hardware=zigbee",
        onlyif => 'lsusb -d 1cf1:0030',
    }
}
