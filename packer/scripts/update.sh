#!/bin/bash -eux

apt-get update
# apt-get install -qy open-vm-tools
apt-get -qy dist-upgrade

if [ -f /var/run/reboot-required ]; then
	reboot
	sleep 60
fi