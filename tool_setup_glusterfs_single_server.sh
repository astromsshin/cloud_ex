#!/bin/bash

# Directory serving the Gluster filesystem
TARGETDIR="/glusterfs/vol"
# Gluster filesystem volume available for clients
TARGETVOL="gvol"
# Name of the Gluster server
VMNAME="test-gl-vm"

# Install the server
apt install glusterfs-server -y
systemctl enable --now glusterd

# Information
gluster --version
systemctl status glusterd

# Prepare the directory
mkdir -p ${TARGETDIR}
# Produce the Gluster filesystem volume with the above directory
gluster volume create ${TARGETVOL} ${VMNAME}:${TARGETDIR} force
# Make the volume available
gluster volume start ${TARGETVOL}

# Information
gluster volume info
gluster volume status
