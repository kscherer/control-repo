# Enable the sensu disk checks
class profile::sensu::check_disk {

  # needed for check_disk
  include ::profile::sensu::packages
  include ::profile::sensu::params
  include ::sensu

  # standalone check must be defined on every sensu client
  sensu::check {
    'check_disk':
      command     => "${::profile::sensu::params::check_path} check_disk --warning=10% --critical=5% --stat-remote-fs --units=GB -X tmpfs -X devtmpfs -X tracefs",
      subscribers => 'disk',
      ttl         => 900,
      interval    => 300,
      standalone  => true;
    'check_ro_mounts':
      command     => "${::profile::sensu::params::check_path} check_ro_mounts -X nfs -X tmpfs",
      subscribers => 'disk',
      ttl         => 900,
      interval    => 300,
      standalone  => true,
      require     => File['check_ro_mounts'];
  }

  file {
    'check_ro_mounts':
      ensure => 'present',
      path   => "${::profile::sensu::params::nagios_plugin_dir}/check_ro_mounts",
      source => 'puppet:///modules/profile/checks/check_ro_mounts',
      mode   => '0755';
  }

  sensu::subscription {'disk': }
}
