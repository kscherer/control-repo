node default {
}

node 'yow-kscherer-d1.wrs.com' {
  include ::ntp
  include ::mcollective
}

node 'ala-blade18.wrs.com' {
  include ::role::puppetserver
}
