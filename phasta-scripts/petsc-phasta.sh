#!/bin/bash

echo "Installing PETSC..."
cd
git clone -b release https://gitlab.com/petsc/petsc.git petsc
cd petsc/
./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-mpich --download-fblaslapack
./configure --prefix=/usr/local 
make all 
sudo make install

echo "Installing Phasta with PETSC..."
cd
if [! -d phasta]; then 
	git clone git@github.com:PHASTA/phasta.git
fi
cd phasta
if [! -d build]; then
	mkdir build
fi
cd build
cmake -DPHASTA_COMPRESSIBLE=ON -DPHASTA_USE_PETSC=ON .. -DMPIEXEC_EXECUTABLE="/usr/local/bin/mpiexec"
make

