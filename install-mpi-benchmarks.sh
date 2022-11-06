#!/bin/bash

cd ~
MYHOME=$(pwd)
mkdir -p matt/local/ompi
cd matt
git clone https://github.com/intel/mpi-benchmarks.git
cd mpi-benchmarks
export CC=/home/testcpu/matt/local/ompi/bin/mpicc
export CXX=/home/testcpu/matt/local/ompi/bin/mpicxx
make all -j 8

