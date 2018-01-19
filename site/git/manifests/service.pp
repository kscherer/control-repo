#
class git::service(
  $gitdir = '/git',
  $daemon = 'UNSET',
) {
  include git
  include git::params
  include git::user

  $daemon_real = $daemon ? {
    'UNSET' => $git::params::daemon,
    default => $daemon,
  }

  ensure_resource('package', $git::params::daemon_package, {'ensure' => 'installed' })

  include xinetd

  xinetd::service {
    'git':
      disable                 => 'no',
      port                    => '9418',
      server                  => $daemon_real,
      server_args             => "--base-path=${gitdir} --max-connections=64 --export-all --syslog --inetd --enable=upload-archive --enable=upload-pack --reuseaddr ${gitdir}",
      socket_type             => 'stream',
      protocol                => 'tcp',
      user                    => 'git',
      # Setting the group triggers massive group lookup to nis and is not needed
      groups                  => 'no',
      wait                    => 'no',
      log_on_success          => '',
      log_on_success_operator => '=',
      log_on_failure          => 'USERID',
      cps                     => '400 2',
      per_source              => '20',
  }

  #to prevent git server from compressing large binary files
  #lower the bigFileThreshold
  file {
    '/home/git/.gitconfig':
      ensure => present,
      owner  => 'git',
      group  => 'git',
      source => 'puppet:///modules/git/gitconfig';
    '/home/git/.gitattributes':
      ensure => present,
      owner  => 'git',
      group  => 'git',
      source => 'puppet:///modules/git/gitattributes';
  }

  Class['git::service'] -> Anchor['git::end']
}
