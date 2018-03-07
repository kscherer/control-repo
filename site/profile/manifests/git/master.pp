# Profile for git mirrors
class profile::git::master {
  include ::profile::git::base
  # include ::git::grokmirror::master

  include ::gitolite
}
