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

  # if apparmor monitoring of docker is completely disabled docker
  # will not work, but forcing it to be in complain mode only works
  # If apparmor is enabled, builds will fail due syslinux behavior
  # of passing a /proc filehandle to a child process
  file {
    '/etc/apparmor.d/force-complain/docker':
      ensure => link,
      target => '/etc/apparmor.d/docker',
      notify => Exec['apparmor_reload'];
  }
  exec {
    'apparmor_reload':
      command     => '/usr/sbin/invoke-rc.d apparmor reload',
      refreshonly => true;
  }
}
