class network {
  if $::facts['network_config'] == 'netplan' {
    include network::netplan
  }
}
