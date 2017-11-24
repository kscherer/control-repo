# Docker profile
class profile::docker {
  include ::profile::base
  include ::docker

  ::consul::service {
    'dockerd':
      service_name => 'dockerd',
      port         => 2375,
      tags         => ['ci'],
      checks       => [
        {
          id       => 'docker_health',
          http     => 'http://127.0.0.1:2375/_ping',
          interval => '10s',
          timeout  => '1s'
        },
      ]
  }
}
