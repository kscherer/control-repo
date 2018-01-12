# Enable the sensu openmanage checks
class profile::sensu::check_openmanage {

  include ::profile::sensu::params
  include ::sensu

  # standalone check must be defined on every sensu client
  sensu::check {
    'check_openmanage':
      command     => "${::profile::sensu::params::check_path}:/usr/bin check_openmanage --state --extinfo --timeout=60 --vdisk-critical --blacklist bat=all --blacklist bat_charge=all",
      subscribers => 'openmanage',
      ttl         => 9000,
      interval    => 3600,
      standalone  => true;
  }

  file {
    'check_openmanage':
      ensure => 'present',
      path   => "${::profile::sensu::params::nagios_plugin_dir}/check_openmanage",
      source => 'puppet:///modules/profile/checks/check_openmanage',
      mode   => '0755';
  }

  sensu::subscription {'openmanage': }
}
