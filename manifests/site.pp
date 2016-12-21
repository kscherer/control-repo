
#set the default path for all exec resources
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

# Disable filebucket by default for all File resources
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

case $::location {
  undef: {
    #This path is used for stdlib facter_dot_d module
    #if location fact is not set by pluginsync, use default from puppet server used
    $location = regsubst($::hostname, '^(\w\w\w).*','\1')
    notice("Using calculated location of ${::location}")
    file {
      '/etc/facter/':
        ensure => directory;
      '/etc/facter/facts.d/':
        ensure => directory;
      '/etc/facter/facts.d/location.txt':
        ensure  => present,
        content => inline_template( 'location=<%= @servername[0..2] %>' );
      '/etc/facter/facts.d/homedir_users.yaml':
        ensure => present,
        source => 'puppet:///modules/profile/homedir_users.yaml';
    }
  }
  default: { } #location properly set, Nothing to do
}

