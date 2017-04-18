# Simple server bootstrap to get packages installed
class { '::puppet':
  server                => true,
  server_foreman        => false,
  server_reports        => 'store',
  server_external_nodes => '',
  server_environments   => [],
}
