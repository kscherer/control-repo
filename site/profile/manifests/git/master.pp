# Profile for git mirrors
class profile::git::master {
  include ::profile::git::base

  # first stage is to mirror existing repos
  include ::git::grokmirror::mirror

  include ::gitolite
}
