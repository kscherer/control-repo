#
class git::cgit {

  package {
    ['cgit', 'highlight', 'python-pygments']:
      ensure => installed;
  }

  file {
    '/etc/cgitrc':
      ensure  => present,
      content => template('git/cgitrc.erb');
    '/home/git/generate_cgit_repolist.sh':
      ensure => present,
      owner  => 'git',
      group  => 'git',
      mode   => '0755',
      source => 'puppet:///modules/git/generate_cgit_repolist.sh';
    '/var/cache/cgit':
      ensure => absent,
  }

  cron {
    'generate_cgit_repolist':
      ensure  => present,
      command => 'export OUTPUT=`mktemp`; /home/git/generate_cgit_repolist.sh > $OUTPUT 2> /dev/null; mv $OUTPUT /home/git/repos.list; chmod 644 /home/git/repos.list',
      user    => 'git',
      minute  => '0';
  }
}
