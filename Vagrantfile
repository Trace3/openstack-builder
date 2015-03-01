# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.7.2"
VAGRANTFILE_API_VERSION = "2"

# Create and configure the VM(s)
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box ="ubuntu/trusty64"

  config.vm.provider "vmware_fusion" do |v, override|
    #override.vm.box = "slowe/ubuntu-trusty-x64"
    override.vm.box = "rbenigno/trusty64"
  end

  # Uncomment to disable synced folder.
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "controller" do |node|
    node.vm.hostname = "controller"
    node.vm.provider "vmware_fusion" do |v|
      v.vmx["numvcpus"] = "1"
      v.vmx["memsize"] = "1024"
    end
  end

  config.vm.define "network" do |node|
    node.vm.hostname = "network"
    node.vm.provider "vmware_fusion" do |v|
      v.vmx["numvcpus"] = "1"
      v.vmx["memsize"] = "512"
    end
    node.vm.network "private_network", ip: "10.199.199.21"
  end

  config.vm.define "compute1" do |node|
    node.vm.hostname = "compute1"
    node.vm.provider "vmware_fusion" do |v|
      v.vmx["numvcpus"] = "1"
      v.vmx["memsize"] = "1024"
    end
    node.vm.network "private_network", ip: "10.199.199.31"
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/site.yml"
    ansible.groups = {
      "controller" => ["controller"],
      "network" => ["network"],
      "compute" => ["compute1"],
      "all_groups:children" => ["controller", "network", "compute"]
    }
  end
end