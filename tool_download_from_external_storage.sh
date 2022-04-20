#!/bin/bash

# edit the folloiwing variables
TARGETDIR="/mnt/mpi"

# assuming webdav accesses
WEBDAVIP="xxxx"
WEBDAVID="xxxx"
WEBDAVPW="xxxx"

# array of filenames that will be downloaded and saved
SRCFNARR=("XCLASS.zip" "ins_custom.sh")
DESTFNARR=("XCLASS.zip" "ins_custom.sh")

cd ${TARGETDIR}

CNT=0
for SRCFN in ${SRCFNARR[@]}
do
  DESTFN=${DESTFNARR[$CNT]}
  wget -O ${DESTFN} --no-check-certificate -r -c --user ${WEBDAVID} --password ${WEBDAVPW} https://${WEBDAVIP}/home/${SRCFN}
  CNT=$((CNT+1))
done
