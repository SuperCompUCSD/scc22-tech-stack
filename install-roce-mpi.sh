#!/bin/bash -e

cd ~
MYHOME=$(pwd)
mkdir -p matt/local/ompi
cd matt
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz
tar -xvzf openmpi-4.1.4.tar.gz
cd openmpi-4.1.4
./configure --prefix=${MYHOME}/matt/local/ompi --with-ucx=${MYHOME}/matt/local/ucx
make all install -j 128

