#!/bin/bash

# Run this script with root permission
# on the master node of the GlusterFS cluster

# Directory serving the Gluster filesystem
TARGETDIR="/glusterfs/vol"
# Gluster filesystem volume available for clients
TARGETVOL="gvol"
# Name of the Gluster cluster
CLUSTERNAME="glustercluster"
MINIONLASTIND="0"

# Install the server
echo "... install on ${CLUSTERNAME}-master"
apt install glusterfs-server -y
systemctl enable --now glusterd
for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... install on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "apt install glusterfs-server -y; systemctl enable --now glusterd"
done

# Probing
for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... probing ${CLUSTERNAME}-minion-${ind}"
  gluster peer probe ${CLUSTERNAME}-minion-${ind}
done

# Prepare the directory
echo "... creating directory on ${CLUSTERNAME}-master"
mkdir -p ${TARGETDIR}
for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... creating directory on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "mkdir -p ${TARGETDIR}"
done

# Information
gluster --version
gluster peer status

# Produce the Gluster filesystem volume with the above directory
VOLSTR="${CLUSTERNAME}-master:${TARGETDIR}"
for ind in $(seq 0 ${MINIONLASTIND})
do
	VOLSTR="${VOLSTR} ${CLUSTERNAME}-minion-${ind}:${TARGETDIR}"
done
gluster volume create ${TARGETVOL} ${VOLSTR} force
# Make the volume available
gluster volume start ${TARGETVOL}

# Information
gluster volume info
