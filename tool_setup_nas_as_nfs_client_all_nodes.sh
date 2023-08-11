#!/bin/bash

# This script mounts the NAS directory with the NFS protocol.

# Name of the cluster which defines the clients' names
CLUSTERNAME="lice"
# Last integer index of the minions in the cluster
MINIONLASTIND="14"
# IP of the Gluster server
NASIP=""
# Directory name which corresponds to the source directory in the NAS
NASDIR="/kvn"
# Directory name which is a mount point on clients
TARGETDIR="/mnt/nas-input"

RUNCMD="apt -y install nfs-common; mkdir ${TARGETDIR}; mount -t nfs ${NASIP}:${NASDIR} ${TARGETDIR}"

echo "... setuping on ${CLUSTERNAME}-master"
echo $RUNCMD | bash

for ind in $(seq 0 ${MINIONLASTIND})
do
	  echo "... setuping on ${CLUSTERNAME}-minion-${ind}"
	    ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
    done

