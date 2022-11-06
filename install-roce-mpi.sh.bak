#!/bin/bash -e

cd ~
MYHOME=$(pwd)
mkdir -p matt/local
cd matt
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz
tar -xvzf openmpi-4.1.4.tar.gz
cd openmpi-4.1.4
./configure --prefix=${MYHOME}/matt/local --with-ucx=/usr/ --with-verbs=/usr/ --with-verbs-libdir=/usr/lib/x86_64-linux-gnu/
make all install -j 128

