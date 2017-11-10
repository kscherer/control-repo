class {'hiera':
  hierarchy => [
    'nodes/%{hostname}',
    '%{location}',
    'hardware/%{boardproductname}',
    'common'
  ],
  datadir   => '/etc/puppetlabs/code/environments/%{::environment}/hiera',
}
