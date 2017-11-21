#
class profile::common::systemd {
  class{
    '::systemd':
      manage_timesyncd => true,
      ntp_server       => join(hiera('ntp::servers'),','),
  }
}
