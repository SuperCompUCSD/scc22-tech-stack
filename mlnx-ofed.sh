#!/bin/sh -e

wget https://www.mellanox.com/downloads/ofed/MLNX_OFED-5.7-1.0.2.0/MLNX_OFED_SRC-debian-5.7-1.0.2.0.tgz
tar -xvzf MLNX_OFED_SRC-debian-5.7-1.0.2.0.tgz
cd MLNX_OFED_SRC-5.7-1.0.2.0/
sudo ./install.pl
