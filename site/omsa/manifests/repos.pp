# == Class: omsa::repos
# Setup the repository for the omsa packages
class omsa::repos {
  case $facts['osfamily'] {
    'Debian': {
      include apt

      $codename = $facts['os']['distro']['codename']
      apt::source {
        'omsa':
          ensure   => present,
          location => "${omsa::repo_base}/${omsa::version}/${codename}",
          release  => $codename,
          repos    => "${codename} main",
          key      => '42550ABD1E80D7C1BC0BAD851285491434D8786F',
      }
      Class['apt::update'] -> Class['omsa::install']
    }
    default: {
      fail("Module ${module_name} is not supported on ${facts['osfamily']}")
    }
  }
}
