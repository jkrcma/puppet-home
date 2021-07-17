class network::netplan (Optional[Array[String]] $interfaces = undef, String $kind = 'lxc') {
  if ($interfaces) {
    $all_interfaces = $interfaces
  } else {
    $all_interfaces = split($::facts['interfaces'], ',')
  }

  $target_interfaces = $all_interfaces - ['lo']
  $path = $kind ? {
    'lxc' => '10-lxc.yaml',
    default => fail("Unknown kind ${kind} for ${name}"),
  }

  file { "/etc/netplan/${path}":
    ensure => present,
    content => template('network/netplan/lxc.yaml.erb'),
  }
}
