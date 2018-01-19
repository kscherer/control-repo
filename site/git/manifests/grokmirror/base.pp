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
}
