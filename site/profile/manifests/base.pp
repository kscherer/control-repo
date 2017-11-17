# Base profile included on all managed nodes
class profile::base {

  include ::profile::common::package_mirrors

  include ::ntp
  Class['profile::common::package_mirrors'] -> Class['ntp']

  include ::mcollective
}
