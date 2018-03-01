#Setup grok mirror on the mirror
class git::grokmirror::mirror(
  $site = 'git.kernel.org',
  $toplevel = '/var/lib/git/mirror',
  $projectslist_symlinks = 'no',
  $post_update_hook = undef,
  $default_owner = 'Grokmirror',
  $loglevel = 'info',
  $include = '*',
  $exclude = undef,
  $pull_threads = 5,
  $fsck_frequency = 30,
  $repack = 'yes',
  $repack_flags = '-A -d -l -q -b',
  $full_repack_every = 10,
  $full_repack_flags = '-A -d -l -q -b -f --window=200 --depth=50',
  $prune = 'yes'
) {

  include git::grokmirror::base
  include git::grokmirror::monitor

  file {
    "${toplevel}/log":
      ensure => directory,
      owner  => 'git',
      group  => 'git';
    "${toplevel}/repos.conf":
      ensure  => file,
      owner   => 'git',
      group   => 'git',
      mode    => '0644',
      content => epp('git/repos.conf.epp',
      {
        site             => $site,
        toplevel         => $toplevel,
        post_update_hook => $post_update_hook,
        pull_threads     => $pull_threads,
        loglevel         => $loglevel,
        include          => $include,
        exclude          => $exclude
      });
    "${toplevel}/fsck.conf":
      ensure  => file,
      owner   => 'git',
      group   => 'git',
      mode    => '0644',
      content => epp('git/fsck.conf.epp',
      {
        site              => $site,
        toplevel          => $toplevel,
        loglevel          => $loglevel,
        fsck_frequency    => $fsck_frequency,
        repack            => $repack,
        repack_flags      => $repack_flags,
        full_repack_every => $full_repack_every,
        full_repack_flags => $full_repack_flags,
        prune             => $prune
      });
  }

  #run the command to actually do the mirroring
  cron {
    'grokmirror_pull':
      ensure  => present,
      command => '/home/git/grok_venv/bin/grok-pull --config /git/repos.conf > /git/log/grok-pull.log 2>&1',
      user    => 'git',
      hour    => '*',
      minute  => '*';
    'force_grokmirror_pull':
      ensure  => present,
      command => 'sleep 30; /home/git/grok_venv/bin/grok-pull --force --config /git/repos.conf > /git/log/grok-pull.log 2>&1',
      user    => 'git',
      hour    => '*',
      minute  => fqdn_rand(60);
    'mirror-kernels':
      command => 'MIRROR=ala-git.wrs.com /git/bin/mirror-kernels',
      user    => 'git',
      minute  => 30;
    'grokmirror_fsck_and_prune':
      command => '/home/git/grok_venv/bin/grok-fsck --config /git/fsck.conf > /git/log/grok-fsck.log 2>&1',
      user    => 'git',
      hour    => 2,
      minute  => 0;
    'mirror_repo_setup':
      command => '/home/git/repo_setup.sh > /dev/null 2>&1',
      user    => 'git',
      hour    => 1,
      minute  => 0;
  }

  include logrotate

  #rotate the grokmirror log files
  logrotate::rule {
    'grokmirror':
      path         => "${toplevel}/log/*.log",
      rotate       => '7',
      rotate_every => 'day',
      missingok    => true,
      ifempty      => false,
      dateext      => true,
      compress     => true;
    'git_cron_log':
      path         => "${toplevel}/cron-kernels.log",
      rotate       => '7',
      rotate_every => 'day',
      olddir       => "${toplevel}/log",
      missingok    => true,
      ifempty      => false,
      dateext      => true,
      compress     => true;
  }

  #make a local non bare clone of the wr-hooks repo to get hook
  #management scripts
  vcsrepo {
    '/git/wr-hooks.git':
      ensure   => bare,
      provider => git,
      source   => 'git://ala-git.wrs.com/wr-hooks.git',
      user     => 'git';
    '/git/wr-hooks':
      ensure   => latest,
      provider => git,
      source   => "git://${::fqdn}/wr-hooks.git",
      user     => 'git',
      revision => 'master',
      require  => Vcsrepo['/git/wr-hooks.git'];
  }

  # setup for http access to wrl9+ release trees
  file {
    '/home/git/sync_files.sh':
      ensure => present,
      owner  => 'git',
      group  => 'git',
      mode   => '0755',
      source => 'puppet:///modules/git/sync_files.sh';
    '/home/git/repo_setup.sh':
      ensure => present,
      owner  => 'git',
      group  => 'git',
      mode   => '0755',
      source => 'puppet:///modules/git/repo_setup.sh';
  }

  cron {
    'sync_files':
      ensure  => present,
      command => '/home/git/sync_files.sh > /dev/null 2>&1',
      user    => 'git',
      minute  => '0';
  }

}
