class profile::system::swap::off {
    if $facts['lsbdistid'] in ['Debian', 'Raspbian'] {
        # Disable swap on Raspberry Pi's
        service { 'dphys-swapfile':
            ensure => stopped,
            enable => false,
        }
    }
}
