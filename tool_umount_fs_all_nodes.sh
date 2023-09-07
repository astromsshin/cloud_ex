#!/bin/bash

# Cluster name
CLUSTERNAME="ml-image"
# Last index of the minions
MINIONLASTIND="8"
# Directory which needs to be umounted
TARGETDIR="/mnt/gluster"


RUNCMD="umount ${TARGETDIR}"

echo "... umount on ${CLUSTERNAME}-master"
echo $RUNCMD | bash

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... umount on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
done
