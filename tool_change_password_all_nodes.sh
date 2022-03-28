#!/bin/bash

CLUSTERNAME="mycluster"
MINIONLASTIND="14"
PWUSER="root"
NEWPASSWORD="xxxxxxxxxx"

echo "... changing ${CLUSTERNAME}-master : ${PWUSER}"
echo -e "${NEWPASSWORD}\n${NEWPASSWORD}" | passwd ${PWUSER}

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... changing ${CLUSTERNAME}-minion-${ind} : ${PWUSER}"
  ssh ${CLUSTERNAME}-minion-${ind} "echo -e \"${NEWPASSWORD}\n${NEWPASSWORD}\" | passwd ${PWUSER}"
done
