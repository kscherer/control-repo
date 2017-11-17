#!/bin/bash

# Assume Ubuntu 16.04+

if [ -z "$MIRROR" ]; then
    MIRROR=ala-mirror.wrs.com
fi

echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/00norecommends

sed -i -e "s#archive.ubuntu.com#$MIRROR/mirror/ubuntu.com#" \
    -e "s#security.ubuntu.com#$MIRROR/mirror/ubuntu.com#" \
    -e '/deb-src/d' /etc/apt/sources.list

apt-get update

if ! hash puppet 2>/dev/null; then
    if [ ! -f /etc/apt/sources.list.d/puppet5.list ]; then
        if ! hash curl 2>/dev/null; then
            apt-get install -y curl
        fi
        curl -o /root/puppet5-release-xenial.deb "http://$MIRROR/mirror/puppetlabs/apt/puppet5-release-xenial.deb"
        dpkg -i /root/puppet5-release-xenial.deb
        sed -i "s#apt.puppetlabs.com#$MIRROR/mirror/puppetlabs/apt#g" /etc/apt/sources.list.d/puppet5.list
        rm -f /root/puppet5-release-xenial.deb
        apt-get update
    fi
    apt install -y puppet-agent lsb-release apt-transport-https
fi

