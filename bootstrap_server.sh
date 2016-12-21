#!/bin/bash -x

# Assume Ubuntu 16.04+

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/00norecommends

if ! hash git 2>/dev/null; then
    apt install -y git
fi

clone_module() {
    local REPO=$1
    local MODULENAME=
    MODULENAME=$(echo "$REPO" | cut -d'-' -f 3)
    if [ ! -d "$MODULENAME" ]; then
        git clone "$REPO" "$MODULENAME"
    fi
}

# Add bootstrap modules
mkdir -p /root/bootstrap/modules
(
    cd /root/bootstrap/modules
    GITSERVER='git://ala-git.wrs.com/external'
    clone_module "${GITSERVER}/extra/github.com.puppetlabs.puppetlabs-stdlib"
    clone_module "${GITSERVER}/extra/github.com.puppetlabs.puppetlabs-inifile"
    clone_module "${GITSERVER}/puppet/github.com.voxpupuli.puppet-hiera"
    clone_module "${GITSERVER}/puppet/github.com.theforeman.puppet-puppet"
    clone_module "${GITSERVER}/extra/github.com.puppetlabs.puppetlabs-concat"
    clone_module "${GITSERVER}/puppet/github.com.voxpupuli.puppet-r10k"
    clone_module "${GITSERVER}/puppet/github.com.puppetlabs.puppetlabs-git"
)

if ! hash puppet 2>/dev/null; then
    apt install -y puppet-agent
fi

# Configure the master, hiera, and r10k services
puppet apply --modulepath=/root/bootstrap/modules master.pp && \
    puppet apply --modulepath=/root/bootstrap/modules hiera.pp && \
    puppet apply --modulepath=/root/bootstrap/modules r10k.pp && \
    # If everything went well, deploy using r10k
    r10k deploy environment -p

