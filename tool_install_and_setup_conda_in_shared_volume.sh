#!/bin/bash

CLUSTERNAME="mycluster"
NFSDIR="/mnt/mpi"

CONDAENV="xclass"
CONDAURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

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
conda install -y -n ${CONDAENV} numpy scipy matplotlib astropy sqlite
# adding pip packages
pip install pyfits
