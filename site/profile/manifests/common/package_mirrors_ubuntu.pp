#
class profile::common::package_mirrors_ubuntu {
  include ::apt
  include ::unattended_upgrades

  $mirror_base = "http://${trusted['extensions']['pp_datacenter']}-mirror.wrs.com/mirror"
  $ubuntu_mirror = "${mirror_base}/ubuntu.com/ubuntu"

  apt::source {
    'ubuntu':
      location => $ubuntu_mirror,
      release  => $facts['lsbdistcodename'],
      repos    => 'main restricted universe multiverse';
    'ubuntu_security':
      location => $ubuntu_mirror,
      release  => "${facts['lsbdistcodename']}-security",
      repos    => 'main restricted universe multiverse';
    'ubuntu_updates':
      location => $ubuntu_mirror,
      release  => "${facts['lsbdistcodename']}-updates",
      repos    => 'main restricted universe multiverse';
    # Due to git CVE-2016-2315 and CVE-2016-2324 update git on all Ubuntu machines
    'git-core-ppa':
      location     => "${mirror_base}/apt/ppa.launchpad.net/git-core/ppa/ubuntu/",
      release      => $facts['lsbdistcodename'],
      repos        => 'main',
      architecture => 'amd64',
      include      => {
        'src'      => false,
      },
      key          => {
        'id'     => 'E1DD270288B4E6030699E45FA1715D88E1DF1F24',
        'server' => 'keyserver.ubuntu.com'
      };
  }

  apt::source {
    'puppetlabs':
      location => "${mirror_base}/puppetlabs/apt",
      release  => $facts['lsbdistcodename'],
      repos    => 'puppet5';
  }
  # Make sure latest release keys are installed
  ensure_resource('package', 'puppet5-release', {'ensure' => 'latest' })

  file {
    #show versions when searching for packages with aptitude
    '/etc/apt/apt.conf.d/90aptitude':
      ensure  => file,
      content => 'Aptitude "";
      Aptitude::CmdLine "";
      Aptitude::CmdLine::Show-Versions "true";
      Aptitude::CmdLine::Package-Display-Format "%c%a%M %p# - %d%V#";
      APT::Install-Recommends "0";';
  }
}
