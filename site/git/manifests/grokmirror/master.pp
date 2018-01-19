#Setup grok mirror on the master
class git::grokmirror::master(
  $docroot = 'UNSET'
) {

  #currently this class is not being used. Look in role::git::master instead
  include git::params
  $docroot_real = $docroot ? {
    'UNSET' => $git::params::docroot,
    default => $docroot,
  }

  include git::grokmirror::base

  file {
    "${docroot_real}/manifest.js.gz":
      ensure => link,
      target => '/git/manifest.js.gz';
  }
}
