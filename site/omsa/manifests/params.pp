# == Class: omsa::params
# Defaults for the omsa module
class omsa::params {
  $ensure_package = 'latest'
  $ensure_service = true
  $enable_service = true
  $force_install  = false
  $version    = '910'

  case $facts['osfamily'] {
    'Debian': {
      $repo_base = 'http://linux.dell.com/repo/community/openmanage'
      $package_name = ['srvadmin-base', 'srvadmin-storageservices', 'srvadmin-omcommon', 'libxslt1.1']
      $service_name = 'dataeng'
    }
    default: {
      fail("Module ${module_name} is not supported on ${facts['osfamily']}")
    }
  }
}
