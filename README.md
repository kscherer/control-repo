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

## Git branch to Puppet Environment mapping

This setup maps git branches to Puppet environments. Note that Puppet
environments only support [a-zA-Z_] and characters like dashes are
mapped to underscores.

Create the new branch using standard git commands:

    git checkout -b <branch>
    git push origin <branch>

Now this new branch can be used by an agent as follows:

    puppet agent --test --environment <branch>

To make the environment selection permanent, change the environment
setting in /etc/puppetlabs/puppet/puppet.conf. If the node uses
theforeman-puppet module, this will be done automatically.

To delete an environment, delete the branch locally and remotely:

    git branch -D <branch>
    git push origin :<branch>

## Docker Test Setup

Using docker to simulate a local test setup for the development of
puppet modules. Puppet has made docker images of the puppetserver and
agent available on Docker Hub.

    docker run -d --rm --name puppet --hostname puppet.wrs.com \
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

- The use of --link puppet allows the agent container to connect to
  the puppetserver using hostname puppet.

- The `apt update` is necessary to allow puppet scripts to install
  packages because the docker image does not ship with the apt database.

- The environment var FACTER_location is used to set the location
  which is used to set configuration like ntp servers. This collection
  of puppet modules supports the following locations: ala, yow and
  pek.

## Docker and systemd

Docker containers do not have a functioning init system like systemd
and some modules that rely on the systemd provider will fail.

To create a base Ubuntu container with the puppet agent setup to run
systemd:

    > make puppet-agent-ubuntu

To run a systemd enabled container the process is more complicated:

    > docker run -d -t --rm --name puppet-agent --hostname <hostname> \
      --link puppet -e FACTER_location=yow --security-opt seccomp=unconfined \
      --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
      --dns-search='wrs.com' windriver/puppet-agent-ubuntu
    > docker exec -it puppet bash -c 'puppet node clean <hostname>'
    > docker exec -it puppet-agent bash
    # puppet agent --test
    # ...
    > docker stop puppet-agent

## Using Puppet apply with Docker

In some cases using puppet apply is simpler and faster than starting
the entire PuppetServer stack.

    > docker run -d -t --rm --name puppet-agent --security-opt seccomp=unconfined \
      --tmp fs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
      -v $PWD:/puppet-control-repo /puppet-agent-ubuntu

This will start an Ubuntu container with systemd as the init
service. The local puppet modules will be bind mounted into the
container at /puppet-control-repo.

Log into the container and run puppet apply:

    > docker exec -it puppet-agent bash
    # apt-get update
    # puppet apply --modulepath /puppet-control-repo/modules:/puppet-control-repo/site \
      --hiera_config /puppet-control-repo/hiera_noeyaml.yaml -e 'include <module>'

Notes:

- The current puppet agent container does not contain eyaml gem and
  cannot decrypt eyaml, so a special hiera config without eyaml is
  used.
- Instead of inline script using -e, place a test.pp file in the root
  of puppet-control-repo and use that instead.

## Acknowledgements

Bootstrapping mechanism: [Puppetinabox](https://github.com/puppetinabox/controlrepo)

Base Template: [Puppet Labs Control-repo](https://github.com/puppetlabs/control-repo)

Docker Test Integration: [Example42 Puppet Systems Infrastructure Contruction Kit](https://github.com/example42/psick)
