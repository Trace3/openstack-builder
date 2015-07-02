#!/bin/sh
set -x

# Script Variables
CONTROLLER=controller

# Load images and configure external networking

export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=labstack
export OS_AUTH_URL=http://$CONTROLLER:35357/v2.0

curl http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img | \
 glance image-create --name "cirros-0.3.3-x86_64" --disk-format qcow2 --container-format bare \
 --is-public True

curl https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img | \
 glance image-create --name "ubuntu_trusty64" --disk-format qcow2 --container-format bare \
 --is-public True --min-disk 2

#curl https://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img | \
# glance image-create --name "ubuntu_precise64" --disk-format qcow2 --container-format bare \
# --is-public True --min-disk 2

# Need to manually download the KVM image from http://www.cloudbase.it/ws2012r2/ (due to EULA)
#gunzip -cd  windows_server_2012_r2_standard_eval_hyperv_20131031.vhd.gz | \
# glance image-create --property --name "windows_server_2012_r2_std_eval" \
# --container-format bare --disk-format qcow2 --is-public True --min-ram 800 --min-disk 32

nova service-list

nova image-list

neutron ext-list

neutron agent-list

neutron net-create ext-net --router:external \
   --provider:physical_network external --provider:network_type flat

neutron subnet-create ext-net --name ext-subnet \
  --allocation-pool start=10.200.200.101,end=10.200.200.200 \
  --disable-dhcp --gateway 10.200.200.2 10.200.200.0/24

# Setup networking for demo tenant and launch an instance

export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=labstack
export OS_AUTH_URL=http://$CONTROLLER:5000/v2.0

neutron net-create demo-net

neutron subnet-create demo-net --name demo-subnet \
  --gateway 192.168.230.1 192.168.230.0/24

neutron router-create demo-router

neutron router-interface-add demo-router demo-subnet

neutron router-gateway-set demo-router ext-net

ping -c 5 10.200.200.101

# Launch an instance

if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa
fi

nova keypair-add --pub-key ~/.ssh/id_rsa.pub demo-key

nova flavor-list
nova image-list
neutron net-list
nova secgroup-list

nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 1 65535 0.0.0.0/0
nova secgroup-add-rule default udp 1 65535 0.0.0.0/0

nova boot --flavor m1.tiny \
  --image cirros-0.3.3-x86_64 \
  --nic net-id=$(neutron net-list | grep demo-net | awk '{print $2}') \
  --security-group default --key-name demo-key demo-instance1

nova list

neutron floatingip-create ext-net

neutron floatingip-list

nova floating-ip-associate demo-instance1 10.200.200.102

nova get-vnc-console demo-instance1 novnc 

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no cirros@10.200.200.102