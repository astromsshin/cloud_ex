#!/bin/bash

RUNCMD='cd /tmp; /mnt/mpi/cloud_ex/tool_install_and_setup_conda_in_local_volume.sh'

CLUSTERNAME="mycluster"
MINIONLASTIND="2"

echo "... install on ${CLUSTERNAME}-master"
echo $RUNCMD | bash

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... install on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
done


