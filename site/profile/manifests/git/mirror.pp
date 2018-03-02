# Profile for git mirrors
class profile::git::mirror {
  include ::profile::git::base
  include ::git::grokmirror::mirror
}
