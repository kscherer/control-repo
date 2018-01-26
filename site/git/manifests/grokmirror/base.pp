#Install and manage grokmirror
class git::grokmirror::base {

  include git::params
  include git::user

  ensure_resource('package', $git::params::python_git, {'ensure' => 'installed' })

  if $::osfamily == 'Debian' {
    ensure_resource('package', 'python-anyjson', {'ensure' => 'installed' })
  }

  vcsrepo {
    '/git/grokmirror':
      ensure   => 'present',
      provider => 'git',
      source   => 'git://ala-git.wrs.com/external/github.com.mricon.grokmirror.git',
      user     => 'git',
      revision => 'master';
  }

  include ::python

  package {
    'virtualenv':
      ensure => present;
  }

  file {
    '/home/git/grok-requirements.txt':
      ensure  => file,
      owner   => 'git',
      group   => 'git',
      source  => 'puppet:///modules/git/grok-requirements.txt',
      require => User['git'];
  }

  ::python::virtualenv {
    'grok_venv':
      ensure       => present,
      requirements => '/home/git/grok-requirements.txt',
      venv_dir     => '/home/git/grok_venv',
      owner        => 'git',
      group        => 'git',
      require      => [File['/home/git/grok-requirements.txt'], User['git']];
  }
}
