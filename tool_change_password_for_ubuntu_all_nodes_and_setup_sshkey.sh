#!/bin/bash

# this script should be executed by root in the master node.

CLUSTERNAME="mlrun"
MINIONLASTIND="6"
PWUSER="ubuntu"
NEWPASSWORD="xxxxxxxxxxxxxx"

KEYSHAREDIR="/tmp"

# changing password of ubuntu account.

echo "... changing ${CLUSTERNAME}-master : ${PWUSER}"
echo -e "${NEWPASSWORD}\n${NEWPASSWORD}" | passwd ${PWUSER}

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... changing ${CLUSTERNAME}-minion-${ind} : ${PWUSER}"
  ssh ${CLUSTERNAME}-minion-${ind} "echo -e \"${NEWPASSWORD}\n${NEWPASSWORD}\" | passwd ${PWUSER}"
done

# generate ssh-key
rm -f ${KEYSHAREDIR}/id_ed25519 ${KEYSHAREDIR}/id_ed25519.pub
### you should type empty passwords by entering twice.
ssh-keygen -t ed25519 << endskey
${KEYSHAREDIR}/id_ed25519
endskey

# setup the environemnt for ssh access withouth password among the cluster nodes
# for ubuntu account
### master
echo "setup the master: ${CLUSTERNAME}-master"
cp -f ${KEYSHAREDIR}/id_ed25519 /home/ubuntu/.ssh/
cp -f ${KEYSHAREDIR}/id_ed25519.pub /home/ubuntu/.ssh/
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_ed25519*
chmod 600 /home/ubuntu/.ssh/id_ed25519
chmod 644 /home/ubuntu/.ssh/id_ed25519.pub
cat /home/ubuntu/.ssh/id_ed25519.pub >> /home/ubuntu/.ssh/authorized_keys
### slaves
for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "setup the slave: ${CLUSTERNAME}-minion-${ind}"
  scp ${KEYSHAREDIR}/id_ed25519 ${CLUSTERNAME}-minion-${ind}:/home/ubuntu/.ssh/
  scp ${KEYSHAREDIR}/id_ed25519.pub ${CLUSTERNAME}-minion-${ind}:/home/ubuntu/.ssh/
  ssh ${CLUSTERNAME}-minion-${ind} "chown ubuntu:ubuntu /home/ubuntu/.ssh/id_ed25519*; chmod 600 /home/ubuntu/.ssh/id_ed25519; chmod 644 /home/ubuntu/.ssh/id_ed25519.pub; cat /home/ubuntu/.ssh/id_ed25519.pub >> /home/ubuntu/.ssh/authorized_keys"
done
