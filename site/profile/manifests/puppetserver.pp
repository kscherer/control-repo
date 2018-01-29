# Common settings for all nodes running a puppet server
class profile::puppetserver
{
  include ::profile::base
  include ::nats

  class {
    '::r10k':
      version           => 'latest',
      sources           => {
        'puppet' => {
          'remote'  => 'git://ala-git.wrs.com/lpd-ops/puppet-control-repo.git',
          'basedir' => $::settings::environmentpath,
          'prefix'  => false,
        },
      },
      postrun_command   => ['/usr/local/bin/clear_environment_cache.sh'],
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

  # foreman report processing
  File {
    '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/reports/foreman.rb':
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0755',
      source => 'puppet:///modules/profile/foreman.rb';
    '/etc/puppetlabs/puppet/foreman.yaml':
      ensure => file,
      owner  => 'puppet',
      group  => 'puppet',
      mode   => '0755',
      source => 'puppet:///modules/profile/foreman.yaml';
    '/usr/local/bin/clear_environment_cache.sh':
      ensure  => file,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0755',
      content => epp('profile/clear_environment_cache.sh.epp',
      {
        fqdn   => $::fqdn,
        server => $::fqdn
      });
  }

  # to access ala-lpd-provision from 105 subnet must use ala-lpd-provision105.
  # but to send reports to ala-lpd-provision over https the certname must match
  # so this /etc/hosts override is needed
  host {
    'ala-lpd-provision.wrs.com':
      ip           => '147.11.105.92',
      host_aliases => 'ala-lpd-provision';
  }

}
