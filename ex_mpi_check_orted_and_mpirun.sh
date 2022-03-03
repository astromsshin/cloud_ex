#!/bin/bash

CLUSTERNAME="mycluster"
MINIONLASTIND="14"

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... checking ${CLUSTERNAME}-minion-${ind}"
  res=$(ssh ${CLUSTERNAME}-minion-${ind} "which orted mpirun" | wc -l)
  if [ ${res} -ne "2" ]
  then
    echo "[WARNING] ${CLUSTERNAME}-minion-${ind} is not ready yet."
  fi
done
