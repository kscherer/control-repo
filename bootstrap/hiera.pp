class {
  'hiera':
    hiera_version   =>  '5',
    hiera5_defaults =>  {
      'datadir'     => '/etc/puppetlabs/code/environments/%{::environment}/hiera',
      'data_hash'   => 'yaml_data'
    },
    hierarchy       =>  [
      {'name' => 'Nodes', 'path'    => 'nodes/%{hostname}.yaml'},
      {'name' => 'Location', 'path' => '%{location}.yaml'},
      {'name' => 'Hardware', 'path' => 'hardware/%{boardproductname}.yaml'},
      {'name' => 'Common', 'path'   => 'common.yaml'},
    ],
}
