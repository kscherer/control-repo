# Class for managing git user
class git::user( $install_ssh_keys = true ) {
  ::profile::user {
    'git':
      password         => '$6$HhVA0LTHPcb5$YYmvCK5STEOdMu1UTmZqj.x/Cjp/oRw83bcjPndY9QPkWeCEbBrd14d5HbicMYx0xcCUHOSgjUQvcJGc/npdl1',
      install_ssh_keys => $install_ssh_keys;
  }
}
