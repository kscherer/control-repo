node default {
  $msg="Using the default profile which is empty.\nAdd a node entry for ${facts['networking']['fqdn']} in manifests/nodes.pp."
  notify { 'using_default': message => $msg }
}

node 'yow-kscherer-d1.wrs.com' {
  include ::ntp
  include ::mcollective
}

node 'ala-blade18.wrs.com' {
  include ::role::puppetserver
  include ::profile::sensu::server
}

node /ala-lpggp[67].wrs.com/ {
  include ::profile::docker
}

node 'ala-blade21.wrs.com' {
  include ::profile::docker
}

node 'yow-git.wrs.com' {
  include ::profile::git::mirror
}

node 'pek-git.wrs.com' {
  include ::profile::git::mirror
}

node 'ala-git-new.wrs.com' {
  include ::profile::git::master
}

node 'ala-danield-node1.wrs.com' {
  include ::profile::common::etc_host_setup
  include ::profile::common::network
  include ::profile::common::package_mirrors
  include ::profile::common::clocksync
}
