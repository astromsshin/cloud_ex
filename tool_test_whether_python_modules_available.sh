#!/bin/bash

CLUSTERNAME="mycluster"
MINIONLASTIND="2"

RUNCMD='echo "Checking on $(hostname)"; python3 -c "from tqdm import tqdm; from astropy.io import fits; from sklearn import mixture; import matplotlib.pyplot as plt; import numpy; print(\"SUCCESS\")"'

echo "... install on ${CLUSTERNAME}-master"
echo $RUNCMD | bash

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... install on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${RUNCMD}"
done

