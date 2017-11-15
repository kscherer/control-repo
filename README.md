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

## Acknowledgements

Bootstrapping mechanism: [Puppetinabox](https://github.com/puppetinabox/controlrepo)

Base Template: [Puppet Labs Control-repo](https://github.com/puppetlabs/control-repo)

Docker Test Integration: [Example42 Puppet Systems Infrastructure Contruction Kit](https://github.com/example42/psick)
