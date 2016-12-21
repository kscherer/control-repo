#
class profile::puppetdb
{

  # Configure puppetdb and its underlying database
  class {
    'puppetdb':
      manage_firewall => false
  }
  # Configure the Puppet master to use puppetdb
  class {
    'puppetdb::master::config':
  }
}
