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
}

node /ala-lpggp[67].wrs.com/ {
  include ::profile::docker
}

node 'ala-blade21.wrs.com' {
  include ::profile::docker
}
