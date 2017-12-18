# == Class: omsa::install
# Setup the repository and install the omsa packages
class omsa::install {
  package {
    $omsa::package_name:
      ensure  => $omsa::ensure_package,
  }
}
