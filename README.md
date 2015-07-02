OpenStack Builder
=================

Creates an OpenStack test environment using Ansible, following the steps in the [Openstack Docs](http://docs.openstack.org/juno/install-guide/install/apt/content/).  Creating on Vagrant, but the Ansible playbooks are meant to be used for installing OpenStack in the LA lab.

This is a work-in-progress and is being done so that I can learn a bit about OpenStack.  Yes, there are better examples out there.

Go ahead and delete this repo if we're running out...

Status
------

**Core**

- [x] Basic environment
- [x] Identity Service
- [x] Image Service
- [x] Compute Service
- [x] Networking Component
- [x] Dashboard

**Optional**

- [ ] Orchestration Module
- [ ] Block Storage
- [ ] Object Storage
- [ ] Telemetry module
- [ ] Database service
- [ ] Data processing service?

TODO
----
- [ ] Move site user accout definitions into a varibles file (common role)
- [ ] Fix DNS resolution within instances (dhcp_sagent.ini - dnsmasq_dns_servers)
- [ ] Auto create external and demo tenant networks
- [ ] Add default images into glance
- [ ] Common user account definitions and ssh keys should come from a vars file
- [ ] Neutron on compute node should edit the nova.conf instead of having gone back to edit the template with neutron settings
- [ ] RabbitMQ should use a dedicated user account (guest pw setting is not currently idempotent)
- [ ] ovs-vsctl add-port br-ex should check if the port exist instead of relying on the bridge creation
- [ ] Don't hard code the external interface used for the ovs external bridge

DONE
----
- [x] Use IP address for external facing service endpoints (instead of "controller")

Instructions
============

For testing I use Vagrant with a pre-updated Ubuntu Box that includes the Juno repo (see packer folder).  This greatly speeds up the initial Ansible playbook run, which is great for dev work.  The playbook runs fine on a clean Ubuntu image, just takes lonnger.

Prerequisites
-------------

1. Python with pip and required packages (including Ansible)
    - Python / pip (easy way is Homebrew - `brew install python`)
    - *Optional*: Create a virtualenv - `pip install virtualenv ; virtualenv ./venv`
    - *Optional*: Activate the virtualenv - `source ./venv/bin/activate`
   	- Install packages - `pip install -r requirements.txt`
2. Vagrant
   - VMware Fusion (might work with VirtualBox, not sure about nested VMs for the compute node)
   - Virtual networks that match the Vagrantfile (the 10.200.200.x network needs external NAT)
   - Vagrant Plugin for Fusion
   - vagrant-hostmanager plugin (`vagrant plugin install vagrant-hostmanager`)

Build with Vagrant
------------------

    # Activate your virtualenv (if you have one)
    source ./venv/bin/activate

    # Go
    vagrant up

Build on Ready Servers
----------------------

