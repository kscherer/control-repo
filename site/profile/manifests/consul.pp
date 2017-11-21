#
class profile::consul {

  file {
    '/opt':
      ensure => directory;
    '/opt/consul':
      ensure => directory;
    '/usr/local/bin':
      ensure => directory;
    '/usr/local/bin/consul':
      ensure => link,
      target => '/opt/consul/consul';
  }

  # Require unzip to install consul packages
  ensure_packages(['unzip'])

  class {
    '::consul':
      config_hash => hiera_hash('consul_config_hash');
  }
}
