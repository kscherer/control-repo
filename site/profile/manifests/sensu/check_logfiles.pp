# Class to manage the check_logfiles script
class profile::sensu::check_logfiles {
  include ::profile::sensu::params
  file {
    'check_logfiles':
      ensure => 'present',
      path   => "${::profile::sensu::params::nagios_plugin_dir}/check_logfiles",
      source => 'puppet:///modules/profile/checks/check_logfiles',
      mode   => '0755';
  }
}
