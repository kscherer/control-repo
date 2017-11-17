# Puppet 5 control repo

This is the control repo used by the Wind River Linux Infrastructure
team at [Wind River](http://windriver.com/products/linux.html)

## Requirement

Tested on Ubuntu 16.04.

Requires: bundler and make

    apt-get install ruby-bundler make

## Setup

To install all the modules locally using r10k:

    make modules

This will install all the ruby gems into .bundle and use r10k to
install all the puppet modules in Puppetfile into the modules/ directory.

## Docker Test Setup

Using docker to simulate a local test setup for the development of
puppet modules. Puppet has made docker images of the puppetserver and
agent available on Docker Hub.

    docker run --rm --name puppet --hostname puppet --dns 127.0.0.11 \
      -v $PWD:/etc/puppetlabs/code/environments/production puppet/puppetserver-standalone

    docker run -it --rm --hostname <hostname> --link puppet -e FACTER_location=ala \
      --entrypoint bash puppet/puppet-agent
    # apt update
    # puppet agent --test

Notes:

- The first run will transfer a _lot_ of custom facts to the
  agent. This is normal and necessary for the proper functioning of
  the Puppet modules.

- The hostname used for the agent container must match an entry in
  manifests/nodes.pp or the default profile will be used. The default
  profile in manifests/nodes.pp is empty.

- The puppetserver is setup to autosign but if the agent container is
  restarted with the same hostname, the certs will not match. Use the
  following command to clear the cert from the puppetserver:

    docker exec -it puppet bash -c 'puppet node clean <hostname>'

- Setting DNS to 127.0.0.11 uses the internal docker DNS server.

- The use of --link puppet allows the agent container to connect to
  the puppetserver using hostname puppet.

- The `apt update` is necessary to allow puppet scripts to install
  packages because the docker image does not ship with the apt database.

- The environment var FACTER_location is used to set the location
  which is used to set configuration like ntp servers. This collection
  of puppet modules supports the following locations: ala, yow and
  pek.

- Docker containers do not have a functioning init system like systemd
  and some modules that rely on the systemd provider will fail.

## Acknowledgements

Bootstrapping mechanism: [Puppetinabox](https://github.com/puppetinabox/controlrepo)

Base Template: [Puppet Labs Control-repo](https://github.com/puppetlabs/control-repo)

Docker Test Integration: [Example42 Puppet Systems Infrastructure Contruction Kit](https://github.com/example42/psick)
