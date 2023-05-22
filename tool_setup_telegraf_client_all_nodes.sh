#!/bin/bash

### [IMPORTANT]
# The root account/permission is required 
# for installation of software by using apt pacakges.
# You should run this script in root account.

# This script makes systems report system status to a telegraf
# monitoring server.
# See https://docs.influxdata.com/telegraf/

# VM information
# If your VM is a single VM, CLUSTERNAME does not matter.
CLUSTERNAME="ml-run"
# If your VM is a single VM not in a cluster configuration put
# **negative integer** in the MINIONLASTIND
MINIONLASTIND="6"
# Telegraf information
# You should type correct information here. Ask the administrator.
MONITORINGSERVERIP="xxx.xxx.xxx.xxx"
MONITORINGSERVERTOKEN="xxxx"
MONITORINGSERVERBUCKET="xxxx"
# ... default template
TEMPLATECFGFN="telegraf.conf.template"
DEFAULTCFGFN="telegraf.conf"

# Modifying the configuration template file.
if [ ! -f ${TEMPLATECFGFN} ]
then
  echo "${TEMPLATECFGFN} is not available."
  exit 1
fi
cp -vf ${TEMPLATECFGFN} ${DEFAULTCFGFN}
sed -i "s/MONITORINGSERVERIP/${MONITORINGSERVERIP}/g" ${DEFAULTCFGFN}
sed -i "s/MONITORINGSERVERTOKEN/${MONITORINGSERVERTOKEN}/g" ${DEFAULTCFGFN}
sed -i "s/MONITORINGSERVERBUCKET/${MONITORINGSERVERBUCKET}/g" ${DEFAULTCFGFN}

# Installing packages
echo "... Installing on ${CLUSTERNAME}-master"
# influxdata-archive_compat.key GPG Fingerprint: 9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install telegraf -y

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... Installing on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "wget -q https://repos.influxdata.com/influxdata-archive_compat.key; echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null; echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list; apt-get update && apt-get install telegraf -y"
done

# Running the daemon
echo "... Configuring and running on ${CLUSTERNAME}-master"
cp -v ${DEFAULTCFGFN} /etc/telegraf/
systemctl restart telegraf

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... Configuring and running on ${CLUSTERNAME}-minion-${ind}"
  scp ${DEFAULTCFGFN} ${CLUSTERNAME}-minion-${ind}:/etc/telegraf/
  ssh ${CLUSTERNAME}-minion-${ind} "systemctl restart telegraf"
done

# Checking the status of the running daemon
read -p 'Do you want to check whetehr the telegraf deamon is running? (y/n)' useranswer
if [ ${useranswer} == "y" ]
then
  echo "[${CLUSTERNAME}-master]"
  systemctl status telegraf
  for ind in $(seq 0 ${MINIONLASTIND})
  do
    echo "${CLUSTERNAME}-minion-${ind}"
    ssh ${CLUSTERNAME}-minion-${ind} "systemctl status telegraf"
  done
fi
