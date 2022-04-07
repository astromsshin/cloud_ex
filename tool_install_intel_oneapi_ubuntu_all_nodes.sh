#!/bin/bash

# See
# https://www.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-using-package-managers/apt.html

install_intel_oneapi='cd /tmp; wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB; apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB; rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB; echo "deb https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list; add-apt-repository "deb https://apt.repos.intel.com/oneapi all main"; apt install -y intel-basekit intel-hpckit'

CLUSTERNAME="mycluster"
MINIONLASTIND="14"

echo "... install on ${CLUSTERNAME}-master"
echo $install_intel_oneapi | bash

for ind in $(seq 0 ${MINIONLASTIND})
do
  echo "... install on ${CLUSTERNAME}-minion-${ind}"
  ssh ${CLUSTERNAME}-minion-${ind} "${intall_intel_oneapi}"
done


