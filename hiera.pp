class {'hiera':
  hierarchy => [
    'nodes/%{hostname}',
    '%{location}',
    '%{operatingsystem}-%{lsbmajdistrelease}-%{architecture}',
    '%{operatingsystem}-%{lsbmajdistrelease}',
    '%{osfamily}',
    'kernel/%{kernelmajversion}',
    'hardware/%{boardproductname}',
    'common'
  ],
  datadir   => '/etc/puppetlabs/code/environments/%{::environment}/hiera',
}
