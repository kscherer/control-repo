# Enable the sensu ntp checks
class profile::sensu::check_ntp {

  # needed for check_ntp_time
  include ::profile::sensu::packages
  include ::profile::sensu::params
  include ::sensu

  # standalone check must be defined on every sensu client
  sensu::check {
    'check_ntp':
      command     => "${::profile::sensu::params::check_path} check_ntp_time -H :::ntp.server|ntp-1.wrs.com::: -w 1.0 -c 2.0",
      subscribers => 'ntp',
      ttl         => 900,
      interval    => 300,
      standalone  => true;
  }

  $ntp_servers = lookup('ntp::servers')
  sensu::subscription {
    'ntp':
      custom => { ntp => { server => $ntp_servers[0] } },
  }
}
