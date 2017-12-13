# Common static networking setup
# Will use network settings from DHCP to populate static networking config
class profile::common::network {
  $subnet = split($facts['networking']['ip'])
  $subnet = join($subnet[0,3], '.')

  network::interface {
    $facts['networking']['primary']:
      method    => 'static',
      ipaddress => $facts['networking']['ip'],
      netmask   => $facts['networking']['netmask'],
      gateway   => "${subnet}.1",
      broadcast => "${subnet}.255",
  }

  class {
    'resolv_conf':
      nameservers => lookup('nameservers'),
      searchpath  => ['wrs.com', 'windriver.com', 'corp.ad.wrs.com'],
  }
}
