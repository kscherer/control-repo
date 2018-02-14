# Common class to handle clock sync
class profile::common::clocksync {

  # Use timesyncd on hosts that use systemd
  if $facts['service_provider'] == 'systemd' {
    include ::profile::common::systemd
  } else {
    # ntp will use conf from dhcp if it is newer and this will override the puppet defined conf
    file {
      '/var/lib/ntp/ntp.conf.dhcp':
        ensure => absent,
        before => Class['ntp'],
        notify => Service['ntp'];
    }

    include ::ntp
    Class['profile::common::package_mirrors'] -> Class['ntp']
  }

  include ::profile::sensu::check_ntp
}
