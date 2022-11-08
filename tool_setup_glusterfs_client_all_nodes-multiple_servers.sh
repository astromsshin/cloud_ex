#!/bin/bash

# Name of the cluster which defines the clients' names
CLUSTERNAME="ml-image"
# Last integer index of the minions in the cluster
MINIONLASTIND="8"
# Directory name which is a mount point on clients
TARGETDIR="/mnt/gluster"

# IP of the Gluster server
GLUSTERSERVERIP="10.0.100.120 10.0.100.191"
# Name of the Gluster server
GLUSTERSERVERNAME="test-basic-master test-basic-minion-0"

# Updating /etc/hosts
IPARRAY=($GLUSTERSERVERIP)
NAMEARRAY=($GLUSTERSERVERNAME)
# ... Master
for (( i=0; i<=${#IPARRAY[@]}; i++ ))
do
	echo ${IPARRAY[$i]} ${NAMEARRAY[$i]} >> /etc/hosts
done
# ... Minion
for ind in $(seq 0 ${MINIONLASTIND})
do
	for (( i=0; i<=${#IPARRAY[@]}; i++ ))
	do
	  ssh ${CLUSTERNAME}-minion-${ind} "echo ${IPARRAY[$i]} ${NAMEARRAY[$i]} >> /etc/hosts"
	done
done

# Rest of tasks 
RUNCMD="apt -y install glusterfs-client; mkdir ${TARGETDIR}; mount -t glusterfs ${GLUSTERSERVERNAME}:/gvol ${TARGETDIR}; chmod -R 777 ${TARGETDIR}"
# ... Master
echo "... setuping on ${CLUSTERNAME}-master"
echo $RUNCMD | bash
# ... Minion
for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... setuping on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
done
