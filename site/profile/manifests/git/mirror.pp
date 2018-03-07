# Profile for git mirrors
class profile::git::mirror {
  include ::git::user
  include ::profile::git::base
  include ::git::grokmirror::mirror
}
