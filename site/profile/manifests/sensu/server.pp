# Base profile for sensu server installation
# Assumes sensu::server: true in hiera for the node
class profile::sensu::server {
  include ::redis
  include ::rabbitmq
  include ::sensu
  include ::uchiwa

  rabbitmq_user {
    'sensu':
      admin    => true,
      password => lookup('sensu::rabbitmq_password'),
      require  => Service['rabbitmq-server'],
      before   => Class['sensu'];
  }

  rabbitmq_user_permissions {
    'sensu@sensu':
      configure_permission => '.*',
      read_permission      => '.*',
      write_permission     => '.*',
      require              => Service['rabbitmq-server'],
      before               => Class['sensu'];
  }

  rabbitmq_vhost {
    'sensu':
      ensure  => present,
      require => Service['rabbitmq-server'],
      before  => Class['sensu'];
  }

  Class['redis'] -> Class['sensu']
  Class['rabbitmq'] -> Class['sensu']
  Class['sensu'] -> Class['uchiwa']

  # active check for zookeeper cluster run on server
  include ::profile::sensu::check_zookeeper

}
