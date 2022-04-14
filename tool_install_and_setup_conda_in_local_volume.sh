#!/bin/bash

CLUSTERNAME="mycluster"
TMPDIR="/tmp"

CONDAENV="xclass"
CONDAURL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# additional apt packages
apt install zip

# installation of miniconda
cd ${TMPDIR}
wget "${CONDAURL}" -O ./miniconda.sh
bash ./miniconda.sh -b -p ${HOME}/miniconda

eval "$(${HOME}/miniconda/bin/conda shell.bash hook)"
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
