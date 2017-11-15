#!/bin/bash -x

# Assume Ubuntu 16.04+

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/00norecommends

sed -i -e 's#archive.ubuntu.com#yow-mirror.wrs.com/mirror/ubuntu.com#' \
  -e 's#security.ubuntu.com#yow-mirror.wrs.com/mirror/ubuntu.com#' \
  -e '/deb-src/d' /etc/apt/sources.list

apt-get update
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
    clone_module "${GITSERVER}/puppet/github.com.theforeman.puppet-puppet"
    clone_module "${GITSERVER}/extra/github.com.puppetlabs.puppetlabs-concat"
    clone_module "${GITSERVER}/puppet/github.com.voxpupuli.puppet-r10k"
    clone_module "${GITSERVER}/puppet/github.com.puppetlabs.puppetlabs-git"
    clone_module "${GITSERVER}/puppet/github.com.puppetlabs.puppetlabs-hocon"
    clone_module "${GITSERVER}/puppet/github.com.puppetlabs.puppetlabs-puppet_authorization"
)

if ! hash puppet 2>/dev/null; then
    if [ ! -f /etc/apt/sources.list.d/puppet5.list ]; then
        if ! hash curl 2>/dev/null; then
            apt-get install -y curl
        fi
        curl -o /root/puppet5-release-xenial.deb http://ala-mirror.wrs.com/mirror/puppetlabs/apt/puppet5-release-xenial.deb
        dpkg -i /root/puppet5-release-xenial.deb
        sed -i 's#apt.puppetlabs.com#ala-mirror.wrs.com/mirror/puppetlabs/apt#g' /etc/apt/sources.list.d/puppet5.list
        rm -f /root/puppet5-release-xenial.deb
        apt-get update
    fi
    apt install -y puppet-agent cron systemd iproute2 lsb-release apt-transport-https
fi

export PATH="/opt/puppetlabs/puppet/bin/:$PATH"
# Configure the master, hiera, and r10k services
puppet apply --modulepath=/root/bootstrap/modules master.pp && \
    puppet apply --modulepath=/root/bootstrap/modules r10k.pp && \
    # If everything went well, deploy using r10k
    r10k deploy environment -p

