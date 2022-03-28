#!/bin/bash

cd /tmp

wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB

apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB

rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB

echo "deb https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list

add-apt-repository "deb https://apt.repos.intel.com/oneapi all main"

apt install -y intel-basekit intel-hpckit
