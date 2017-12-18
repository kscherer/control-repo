# == Class: omsa::service
# Manages the openmanage service dataeng
class omsa::service {
  service {
    $omsa::service_name:
      ensure     => $omsa::ensure_service,
      enable     => $omsa::enable_service,
      hasrestart => true,
      hasstatus  => true,
      require    => Package[$omsa::package_name],
  }
}
