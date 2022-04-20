#!/bin/bash

# edit the folloiwing variables
# assuming webdav accesses
WEBDAVIP="xxxx"
WEBDAVID="xxxx"
WEBDAVPW="xxxx"

# array of filenames that will be downloaded and saved
SRCFNARR=("/root/.ssh/id_rsa.pub")
DESTFNARR=("cluster_master_id_rsa.pub")

CNT=0
for SRCFN in ${SRCFNARR[@]}
do
  DESTFN=${DESTFNARR[$CNT]}
  curl --insecure -u ${WEBDAVID}:${WEBDAVPW} -T ${SRCFN} https://${WEBDAVIP}/home/${DESTFN}
  CNT=$((CNT+1))
done
