# Class for managing git user
class git::user {
  ::profile::user {
    'git':
      password   => '$6$HhVA0LTHPcb5$YYmvCK5STEOdMu1UTmZqj.x/Cjp/oRw83bcjPndY9QPkWeCEbBrd14d5HbicMYx0xcCUHOSgjUQvcJGc/npdl1';
  }
}
