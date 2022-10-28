#!/bin/bash
wget https://fluid.colorado.edu/~kjansen/PHASTA/Scripts.tar
tar -xvf Scripts.tar
git clone https://github.com/SCOREC/core
cd deps
./do.sh
cd ..
. ./env
mkdir build
cp doConfNoSim.sh build
cd build
./doConfNoSim.sh
