
#set the default path for all exec resources
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

# Disable filebucket by default for all File resources
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

if empty($trusted['extensions']['pp_datacenter']) {
  fail('Trusted datacenter fact not found. Create csr_attributes and regen certs.')
}
