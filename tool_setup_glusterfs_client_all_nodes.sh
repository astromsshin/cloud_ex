#!/bin/bash

# Name of the cluster which defines the clients' names
CLUSTERNAME="ml-image"
# Last integer index of the minions in the cluster
MINIONLASTIND="8"
# IP of the Gluster server
GLUSTERSERVERIP="10.0.100.150"
# Name of the Gluster server
GLUSTERSERVERNAME="test-gl-vm"
# Directory name which is a mount point on clients
TARGETDIR="/mnt/gluster"


RUNCMD="apt -y install glusterfs-client; echo ${GLUSTERSERVERIP} ${GLUSTERSERVERNAME} >> /etc/hosts;mkdir ${TARGETDIR}; mount -t glusterfs ${GLUSTERSERVERNAME}:/gvol ${TARGETDIR}"

echo "... setuping on ${CLUSTERNAME}-master"
echo $RUNCMD | bash

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... setuping on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
done
