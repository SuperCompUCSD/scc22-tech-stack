#!/bin/bash
cd 
if [ -d gmsh_phasta ]
then
        rm -r gmsh_phasta
fi
mkdir gmsh_phasta
cd gmsh_phasta

wget https://fluid.colorado.edu/~kjansen/PHASTA/Scripts.tar
tar -xvf Scripts.tar
echo "Getting SCOREC/core..."
git clone https://github.com/SCOREC/core

cd deps
echo "Building GKlib, METIS, and PartMETIS..."
./do.sh

cd ..
echo "Setting environment..."
. ./env
mkdir build

cp doConfNoSim.sh build
cd build
echo "Configuring Chef with CMake..."
./doConfNoSim.sh

echo "Building chef and from_gmsh..."
# If failed this step, go to core/CMakeLists.txt and add these 2 lines
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I/usr/include/c++/11 -I/usr/include/x86_64-linux-gnu/c++/11")
# set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS}")
make -j chef
make -j from_gmsh 
