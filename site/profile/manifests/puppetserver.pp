# Common settings for all nodes running a puppet server
class profile::puppetserver
{
  include ::profile::base
  include ::nats

  class {
    '::r10k':
      version         => 'latest',
      sources         => {
        'puppet' => {
          'remote'  => 'git://ala-git.wrs.com/lpd-ops/puppet-control-repo.git',
          'basedir' => $::settings::environmentpath,
          'prefix'  => false,
        },
      },
    manage_modulepath => false
  }

  # Instead of running via mco, run r10k directly
  class {
    '::r10k::webhook::config':
      use_mcollective  => false,
      protected        => false,
      public_key_path  => "/etc/puppetlabs/puppet/ssl/ca/signed/${facts['fqdn']}.pem",
      private_key_path => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['fqdn']}.pem",
      notify           => Service['webhook'],
  }
  # since webhook uses puppetdb certs it needs to be installed first
  Package['puppetdb'] ->  Service[webhook]

  # The hook needs to run as root when not running using mcollective
  # It will issue r10k deploy environment <branch_from_gitlab_payload> -p
  # When git pushes happen.
  class {
    '::r10k::webhook':
      use_mcollective => false,
      user            => 'puppet',
      group           => 'puppet',
      require         => Class['r10k::webhook::config'],
  }
}
