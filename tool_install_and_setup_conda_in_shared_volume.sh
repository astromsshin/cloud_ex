#!/bin/bash

CLUSTERNAME="mycluster"
NFSDIR="/mnt/mpi"

### [IMPORTANT]
# Because this script uses the directory ${NFSDIR}/miniconda
# as a Conda directory, the account running this script must have 
# a permission to create/write the directory ${NFSDIR}/miniconda.
# One way is to create the directory ${NFSDIR}/miniconda as root user,
# and then the owner of the directory is changed to the account running 
# this script. For example, as root account, 
# mkdir /mnt/mpi/miniconda
# chown ubuntu:ubuntu /mnt/mpi/miniconda
# if you like to use the conda environment as ubuntu account and you are
# running this script as ubuntu account.

CONDAENV="xclass"
CONDAURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# additional apt packages
# [IMPORTANT] this requires root permission
# If you like to install apt pacakges separately in root account,
# delete the following part.
sudo apt install zip

# installation of miniconda
cd ${NFSDIR}
wget "${CONDAURL}" -O ./miniconda.sh
bash ./miniconda.sh -b -p ${NFSDIR}/miniconda

eval "$(${NFSDIR}/miniconda/bin/conda shell.bash hook)"
conda init
conda update -y -n base -c defaults conda

# creating the environment
conda create -y -n ${CONDAENV} python=2.7
# adding new conda packages
conda install -y -n ${CONDAENV} numpy
conda install -y -n ${CONDAENV} scipy
conda install -y -n ${CONDAENV} matplotlib
conda install -y -n ${CONDAENV} astropy
conda install -y -n ${CONDAENV} sqlite
# adding pip packages
conda activate ${CONDAENV}
pip install pyfits

echo "Do the following things to use the environment ${CONDAENV}"
echo "1) source ~/.bashrc"
echo "2) conda activate ${CONDAENV}"
