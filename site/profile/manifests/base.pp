# Base profile included on all managed nodes
class profile::base {

  include ::profile::common::etc_host_setup
  include ::profile::common::package_mirrors
  include ::profile::common::network
  include ::puppet
  include ::omsa

  if $facts['service_provider'] == 'systemd' {
    include ::profile::common::systemd
  } else {
    include ::ntp
    Class['profile::common::package_mirrors'] -> Class['ntp']
  }

  if $facts['virtual'] != 'docker' {
    include ::mcollective

    include ::profile::consul
    Class['profile::common::package_mirrors'] -> Class['profile::consul']
  }

  ::profile::user {
    'root':
      password   => '$6$ToFoBwzOwdxavNb6$0ibeb/nW.BPqkdBjRI4XLKJxVWzuu583WSajpC/TvE3H4YGzvqWkK0WAs5JsRiYItarQr3vMa0mfBXtuXBulm1',
      managehome => false;
  }
}
