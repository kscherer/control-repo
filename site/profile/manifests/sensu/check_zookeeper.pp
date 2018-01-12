# Enable the sensu zookeeper checks
class profile::sensu::check_zookeeper {

  include ::profile::sensu::params
  include ::sensu

  # standalone check must be defined on every sensu client
  sensu::check {
    'check_zookeeper':
      command     => "${::profile::sensu::params::check_path} check_zookeeper.sh",
      subscribers => 'zookeeper',
      standalone  => false,
      ttl         => 4500,
      interval    => 1800;
  }

  file {
    'check_zookeeper':
      ensure => 'present',
      path   => "${::profile::sensu::params::nagios_plugin_dir}/check_zookeeper.sh",
      source => 'puppet:///modules/profile/checks/check_zookeeper.sh',
      mode   => '0755';
  }

  sensu::subscription {'zookeeper': }
}
