OpenStack Builder
=================

Creates an OpenStack test environment using Ansible, following the steps in the [Openstack Docs](http://docs.openstack.org/juno/install-guide/install/apt/content/).  Creating on Vagrant, but the Ansible playbooks are meant to be used for installing OpenStack in the LA lab.

This is a work-in-progress and is being done so that I can learn a bit about OpenStack.  Yes, there are better examples out there.

Go ahead and delete this repo if we're running out...

Status
------

- [x] Basic environment
- [x] Identity Service
- [x] Image Service
- [x] Compute Service
- [x] Networking Component
- [ ] Dashboard
- [ ] Block Storage
- [ ] Object Storage
- [ ] Orchestration Module
- [ ] Telemetry module
- [ ] Database service
- [ ] Data processing service?

TODO
----
- [ ] Use IP address for external facing service endpoints (instead of "controller")
- [ ] Common user account definitions and ssh keys should come from a vars file
- [ ] Neutron on compute node should edit the nova.conf instead of having gone back to edit the template with neutron settings
- [ ] RabbitMQ should use a dedicated user account (guest pw setting is not currently idempotent)
- [ ] ovs-vsctl add-port br-ex should check if the port exist instead of relying on the bridge creation
- [ ] Don't hard code the external interface used for the ovs external bridge