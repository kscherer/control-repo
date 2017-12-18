# == Class: omsa
# Puppet module to install, deploy and configure Dell OpenManage Service
class omsa (
  $ensure_package = $omsa::params::ensure_package,
  $ensure_service = $omsa::params::ensure_service,
  $enable_service = $omsa::params::enable_service,
  $force_install  = $omsa::params::force_install,
  $package_name   = $omsa::params::package_name,
  $service_name   = $omsa::params::service_name,
  $repo_base      = $omsa::params::repo_base,
  $version        = $omsa::params::version
) inherits omsa::params {
  if ($facts['virtual'] == 'physical') and ($facts['dmi']['manufacturer'] == 'Dell Inc.')
    or ($force_install == true) {
      contain omsa::repos
      contain omsa::install
      contain omsa::service

      Class['omsa::repos'] -> Class['omsa::install'] ~> Class['omsa::service']
  }
}
