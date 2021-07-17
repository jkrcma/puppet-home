class network {
  stage { 'network':
      before => Stage['apt'],
  }

  if $::facts['network_config'] == 'netplan' {
    class { 'network::netplan': stage => 'network' }
  } elsif $::facts['network_config'] == 'ifupdown' {
    package { 'vlan':
        ensure => latest,
    }
    class { 'network::ifupdown': stage => 'network' }
    include network::ifupdown::vlan
  } else {
    fail("${module_name}: Unknown network provider: ${::facts['network_config']}")
  }
}
