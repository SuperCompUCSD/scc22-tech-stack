#!/bin/bash -e

sudo apt-get update
sudo apt-get install gnupg2
for ID in $(getent passwd {1000..2000} | awk -F ':' '{ print $1 }') ; do sudo usermod -aG render "$ID"; sudo usermod -aG video "$ID"; done
wget https://repo.radeon.com/amdgpu-install/5.3/ubuntu/focal/amdgpu-install_5.3.50300-1_all.deb
apt-get install ./amdgpu-install_5.3.50300-1_all.deb

