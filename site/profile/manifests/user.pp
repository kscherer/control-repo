# reduce boilerplate with user definition
define profile::user( $password, $managehome = true ) {
  if $name == 'root' {
    $home = '/root'
  } else {
    $home = "/home/${name}"
  }
  user {
    $name:
      ensure     => present,
      groups     => $name,
      home       => $home,
      shell      => '/bin/bash',
      managehome => $managehome,
      password   => $password;
  }

  group {
    $name:
      ensure => present;
  }

  ssh_authorized_key {
    "kscherer_desktop_${name}":
      ensure => 'present',
      user   => $name,
      key    => hiera('kscherer@yow-kscherer-d1'),
      type   => 'ssh-rsa';
    "kscherer_laptop_${name}":
      ensure => 'present',
      user   => $name,
      key    => hiera('kscherer@yow-kscherer-l1'),
      type   => 'ssh-rsa';
    "kscherer_argon_${name}":
      ensure => 'present',
      user   => $name,
      key    => hiera('kscherer@argon'),
      type   => 'ssh-rsa';
    "ywang_${name}":
      ensure => 'present',
      user   => $name,
      key    => hiera('ywang@yow-lpdtest'),
      type   => 'ssh-rsa';
  }

  file {
    "${home}/.bashrc":
      ensure => present,
      owner  => $name,
      group  => $name,
      mode   => '0755',
      source => 'puppet:///modules/profile/bashrc';
    "${home}/.aliases":
      ensure => present,
      owner  => $name,
      group  => $name,
      mode   => '0755',
      source => 'puppet:///modules/profile/aliases';
    "${home}/.tmux.conf":
      ensure => present,
      owner  => $name,
      group  => $name,
      mode   => '0755',
      source => 'puppet:///modules/profile/tmux.conf';
    "${home}/.bash_profile":
      ensure  => present,
      owner   => $name,
      group   => $name,
      content => 'if [ -f $HOME/.bashrc ]; then source $HOME/.bashrc; fi';
  }
}
