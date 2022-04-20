#!/bin/bash

# list packages
# search and check packages in https://packages.ubuntu.com/
# for Ubuntu distributions
pkgs=(astropy-utils python3-astropy python3-astropy-affiliated python3-astropy-healpix python3-astropy-helpers python3-sklearn python3-skimage python3-statsmodels python3-matplotlib python3-tqdm)

CLUSTERNAME="mycluster"
MINIONLASTIND="14"

echo "... install on ${CLUSTERNAME}-master"
apt update -y
for pkg in ${pkgs[@]}
do
  apt install $pkg -y
done

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... install on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "apt update -y"
  for pkg in ${pkgs[@]}
  do
    ssh ${CLUSTERNAME}-minion-${ind} "apt install ${pkg} -y"
  done
done


