class { 'r10k':
  version           => 'latest',
  sources           => {
    'puppet' => {
      'remote'  => 'git://ala-git.wrs.com/lpd-ops/puppet-control-repo.git',
      'basedir' => $::settings::environmentpath,
      'prefix'  => false,
    },
  },
  manage_modulepath => false
}
