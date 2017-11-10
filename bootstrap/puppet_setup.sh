#!/bin/bash

codename=$(lsb_release -cs)
echo_title "Adding $codename repo for Puppet 5"
wget -q "http://ala-mirror.wrs.com/mirror/puppetlabs/apt/puppet5-release-${codename}.deb" >/dev/null
dpkg -i "puppet5-release-${codename}.deb" >/dev/null
apt-get update
