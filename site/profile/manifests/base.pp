# Base profile included on all managed nodes
class profile::base {

  include ::profile::common::package_mirrors

  if $facts['service_provider'] == 'systemd' {
    include ::profile::common::systemd
  } else {
    include ::ntp
    Class['profile::common::package_mirrors'] -> Class['ntp']
  }

  include ::mcollective

  include ::profile::consul
  Class['profile::common::package_mirrors'] -> Class['profile::consul']
}
