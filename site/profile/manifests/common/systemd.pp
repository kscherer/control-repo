#
class profile::common::systemd {

  class{
    '::systemd':
      manage_timesyncd => $facts['virtual'] != 'docker',
      ntp_server       => join(hiera('ntp::servers'),','),
  }
}
