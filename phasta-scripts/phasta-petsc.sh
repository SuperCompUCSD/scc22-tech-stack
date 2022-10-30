#!/bin/bash -e

echo "Installing PETSC..."
cd
if [ -d "$HOME/petsc" ];
then
        sudo rm -r ~/petsc	
fi
git clone -b release https://gitlab.com/petsc/petsc.git petsc
cd petsc/
sudo ./configure --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 --download-fblaslapack=1 --prefix=/usr/local
sudo make all
sudo make install
echo "Installing Phasta with PETSC..."
cd
if [ -d "$HOME/phasta" ];
then
        sudo rm -r ~/phasta	
fi
git clone git@github.com:PHASTA/phasta.git
cd phasta
mkdir build
cd build
MPIEXEC=(which mpiexec)
cmake \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DCMAKE_Fortran_COMPILER=gfortran \
-DCMAKE_Fortran_FLAGS="-fallow-argument-mismatch -pg" \
-DCMAKE_BUILD_TYPE=Debug \
-DPHASTA_INCOMPRESSIBLE=OFF \
-DPHASTA_COMPRESSIBLE=ON \
-DPHASTA_USE_SVLS=OFF \
-DPHASTA_USE_PETSC=ON \
-DCMAKE_C_FLAGS="-pg" \
-DCMAKE_CXX_FLAGS="-pg" \
-DMPIEXEC_EXECUTABLE="$MPIEXEC" \
..
echo "Building Phasta executable..."
make -j phastaC.exe

cd ~/phasta
echo "Getting phastaChef tests..."
wget https://fluid.colorado.edu/~kjansen/PHASTA/phastaChefTests.tar.gz
tar -xzf phastaChefTests.tar.gz
