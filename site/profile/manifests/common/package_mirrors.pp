#
class profile::common::package_mirrors {
  case $::operatingsystem {
    'Ubuntu': {
      include ::profile::common::package_mirrors_ubuntu
      include ::unattended_upgrades

      # make sure apt update runs right after sources are changed
      anchor{'profile::common::package_mirrors::begin': }
      -> Class['profile::common::package_mirrors_ubuntu']
      -> Class['Apt::Update']
      -> anchor{'profile::common::package_mirrors::end': }
      -> Class['Unattended_upgrades']
    }
    default: { fail("Unsupported OS ${::operatingsystem}") }
  }
}
