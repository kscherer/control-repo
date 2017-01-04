# Base profile included on all managed nodes
class profile::base {

  include ::ntp
  include ::mcollective

}
