#!/bin/bash -eux

case "$PACKER_BUILDER_TYPE" in 

vmware-iso|vmware-ovf) 
    mkdir /tmp/vmtools
    mkdir /tmp/vmtools-archive
    mount -o loop /home/vagrant/linux.iso /tmp/vmtools
    tar xzf /tmp/vmtools/VMwareTools-*.tar.gz -C /tmp/vmtools-archive
    # PATCH FOR NEWER KERNEL (SHOULD PROBABLY CHECK THE KERNEL VERSION FIRST)
    cd /tmp/vmtools-archive/vmware-tools-distrib/lib/modules/source
    tar xf vmhgfs.tar
    sed -i -e s/d_alias/d_u.d_alias/ vmhgfs-only/inode.c
    tar cf vmhgfs.tar vmhgfs-only
    # END PATCH
    /tmp/vmtools-archive/vmware-tools-distrib/vmware-install.pl --default
    umount /tmp/vmtools
    rm -rf  /tmp/vmtools
    rm -rf  /tmp/vmtools-archive
    rm /home/vagrant/*.iso
    ;;

*)
    echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
    ;;

esac