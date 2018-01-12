# Common class to handle clock sync
class profile::common::clocksync {

  # Use timesyncd on hosts that use systemd
  if $facts['service_provider'] == 'systemd' {
    include ::profile::common::systemd
  } else {
    include ::ntp
    Class['profile::common::package_mirrors'] -> Class['ntp']
  }

  include ::profile::sensu::check_ntp
}
