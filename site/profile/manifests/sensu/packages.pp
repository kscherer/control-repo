# Class to install all package with monitoring checks
class profile::sensu::packages {
  package {
    'monitoring-plugins-basic':
      ensure => installed;
  }
}
