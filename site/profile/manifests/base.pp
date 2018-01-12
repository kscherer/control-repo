# Base profile included on all managed nodes
class profile::base {
  include ::profile::common::package_mirrors

  # Does not make sense to configure a lot of things inside a container
  if $facts['virtual'] != 'docker' {
    include ::profile::common::etc_host_setup
    include ::profile::common::network
    include ::profile::common::clocksync

    # enable puppet agent run on cron every 30 minutes
    include ::puppet
    include ::mcollective

    # All hosts get disk checks
    include ::profile::sensu::check_disk

    # Dell machines get OpenManage and hardware checking
    if ($facts['virtual'] == 'physical') and ($facts['dmi']['manufacturer'] == 'Dell Inc.') {
      include ::omsa
      include ::profile::sensu::check_openmanage
    }

    include ::profile::consul
    Class['profile::common::package_mirrors'] -> Class['profile::consul']

    ::profile::user {
      'root':
        password   => '$6$ToFoBwzOwdxavNb6$0ibeb/nW.BPqkdBjRI4XLKJxVWzuu583WSajpC/TvE3H4YGzvqWkK0WAs5JsRiYItarQr3vMa0mfBXtuXBulm1',
        managehome => false;
    }
  }
}
