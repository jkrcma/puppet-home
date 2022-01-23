class network {
  if $::facts['network_config'] == 'netplan' {
    include network::netplan
  } elsif $::facts['network_config'] == 'ifupdown' {
    package { ['bridge-utils', 'vlan']:
        ensure => latest,
        before => Class['network::ifupdown::vlan'],
    }
    include network::ifupdown
    include network::ifupdown::vlan
  } else {
    fail("${module_name}: Unknown network provider: ${::facts['network_config']}")
  }
}
