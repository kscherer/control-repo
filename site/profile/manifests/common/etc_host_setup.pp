#
class profile::common::etc_host_setup {
  #Make sure that the machine is in the hosts file
  if $facts['domain'] == 'wrs.com' {
    host {
      $::fqdn:
        ip           => $facts['networking']['ip'],
        host_aliases => $::hostname;
    }
  } else {
    host {
      "${::hostname}.wrs.com":
        ip           => $facts['networking']['ip'],
        host_aliases => $::hostname;
    }
  }
  host {
    'localhost':
      host_aliases => 'localhost.localdomain',
      ip           => '127.0.0.1';
  }
}
