#!/bin/bash -e
echo "Installing Phasta without PETSC..."
cd
if [ -d "$HOME/phasta" ];
then
        sudo rm -r phasta
fi
git clone git@github.com:PHASTA/phasta.git
cd phasta
mkdir build
cd build
cmake \
-DCMAKE_C_COMPILER=mpicc \
-DCMAKE_CXX_COMPILER=mpic++ \
-DCMAKE_Fortran_COMPILER=mpif90 \
-DCMAKE_BUILD_TYPE=Debug \
-DPHASTA_INCOMPRESSIBLE=OFF \
-DPHASTA_COMPRESSIBLE=ON \
-DPHASTA_USE_SVLS=OFF \
-DPHASTA_USE_PETSC=OFF \
..
echo "Building Phasta executable..."
make -j phastaC.exe

cd ~/phasta
echo "Getting phastaChef tests..."
wget https://fluid.colorado.edu/~kjansen/PHASTA/phastaChefTests.tar.gz
tar -xzf phastaChefTests.tar.gz
