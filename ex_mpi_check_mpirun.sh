#!/bin/bash

CLUSTERNAME="mycluster"
MINIONLASTIND="14"

echo "... checking ${CLUSTERNAME}-master"
res=$(which mpirun | wc -l)
if [ ${res} -ne "1" ]
then
  echo "[WARNING] ${CLUSTERNAME}-master is not ready yet."
fi

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... checking ${CLUSTERNAME}-minion-${ind}"
  res=$(ssh ${CLUSTERNAME}-minion-${ind} "which mpirun" | wc -l)
  if [ ${res} -ne "1" ]
  then
    echo "[WARNING] ${CLUSTERNAME}-minion-${ind} is not ready yet."
  fi
done
