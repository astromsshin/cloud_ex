#!/bin/bash

# Name of the cluster which defines the clients' names
CLUSTERNAME="lice"
# Last integer index of the minions in the cluster
MINIONLASTIND="14"
# Directory name which is a mount point on clients
TARGETDIR="/mnt/gluster-input"

# IP of the Gluster server
GLUSTERSERVERIP="10.0.110.167 10.0.110.92 10.0.110.124 10.0.110.68 10.0.110.104 10.0.110.172 10.0.110.44 10.0.110.147 10.0.110.67 10.0.110.185 10.0.110.31 10.0.110.225"
# Name of the Gluster server
GLUSTERSERVERNAME="gluster-input-master gluster-input-minion-0 gluster-input-minion-1 gluster-input-minion-2 gluster-input-minion-3 gluster-input-minion-4 gluster-input-minion-5 gluster-input-minion-6 gluster-input-minion-7 gluster-input-minion-8 gluster-input-minion-9 gluster-input-minion-10"

IPARRAY=($GLUSTERSERVERIP)
NAMEARRAY=($GLUSTERSERVERNAME)

# Deleting exisitng entries in /etc/hosts
echo "Deleting existing entries in /etc/hosts"
# ... Master
for (( i=0; i<=${#IPARRAY[@]}; i++ ))
do
	sed -i "/ ${NAMEARRAY[$i]}$/d" /etc/hosts
	sed -i "/ ${IPARRAY[$i]}$/d" /etc/hosts
done
# ... Minion
for ind in $(seq 0 ${MINIONLASTIND})
do
	for (( i=0; i<=${#IPARRAY[@]}; i++ ))
	do
	  ssh ${CLUSTERNAME}-minion-${ind} "sed -i \"/${NAMEARRAY[$i]}/d\" /etc/hosts; sed -i \"/${IPARRAY[$i]}/d\" /etc/hosts"
	done
done


# Updating /etc/hosts
echo "Adding entries in /etc/hosts"
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
echo "Running the relevant commands"
RUNCMD="apt -y install glusterfs-client; mkdir ${TARGETDIR}; mount -t glusterfs ${NAMEARRAY[0]}:/gvol ${TARGETDIR}; chmod -R 777 ${TARGETDIR}"
# ... Master
echo "... setuping on ${CLUSTERNAME}-master"
echo $RUNCMD | bash
# ... Minion
for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... setuping on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
done
