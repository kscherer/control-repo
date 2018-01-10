# Enable the sense ntp checks
class profile::sensu::ntp {

  # needed for check_ntp_time
  include ::profile::sensu::packages

  include ::sensu

  # standalone check must be defined on every sensu client
  sensu::check {
    'ntp':
      command     => '/usr/lib/nagios/plugins/check_ntp_time -H :::ntp.server|ntp-1.wrs.com::: -w 1.0 -c 2.0',
      subscribers => 'ntp',
      standalone  => true;
  }

  $ntp_servers = lookup('ntp::servers')
  sensu::subscription {
    'ntp':
      custom => { ntp => { server => $ntp_servers[0] } },
  }
}
