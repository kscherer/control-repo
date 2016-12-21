# Common settings for all nodes running a puppet server
class profile::puppetserver
{
  class {
    '::puppet':
      server                      => true,
      server_foreman              => false,
      server_reports              => 'store',
      server_storeconfigs_backend => 'puppetdb',
      server_external_nodes       => '',
      server_environments         => [],
      server_common_modules_path  => [],
  }
}
