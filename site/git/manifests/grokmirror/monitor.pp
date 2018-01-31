#
class git::grokmirror::monitor {
  # needed for check_disk
  include ::profile::sensu::packages
  include ::profile::sensu::params
  include ::profile::sensu::check_logfiles
  include ::sensu

  # standalone check must be defined on every sensu client
  sensu::check {
    'check_grokmirror':
      command     => "${::profile::sensu::params::check_path} check_logfiles --config ${::profile::sensu::params::nagios_plugin_dir}/grokmirror.cfg",
      subscribers => 'grokmirror',
      ttl         => 2800,
      interval    => 900,
      standalone  => true;
    'check_grokmirror_log_age':
      command     => "${::profile::sensu::params::check_path} check_file_age -w 7200 -c 14400 -f /git/log/ala-git.wrs.com.log",
      subscribers => 'grokmirror',
      ttl         => 900,
      interval    => 300,
      standalone  => true;
  }

  file {
    'grokmirror.cfg':
      ensure => 'present',
      path   => "${::profile::sensu::params::nagios_plugin_dir}/grokmirror.cfg",
      source => 'puppet:///modules/profile/checks/grokmirror.cfg',
      mode   => '0755';
  }

  sensu::subscription {'grokmirror': }
}
