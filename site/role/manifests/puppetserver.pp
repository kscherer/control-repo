#
class role::puppetserver {
  include ::profile::puppetserver
  include ::profile::puppetdb
}
