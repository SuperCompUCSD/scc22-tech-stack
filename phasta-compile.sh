#!/bin/bash
git clone https://github.com/PHASTA/phasta.git
cd phasta
module purge
module load DefaultModules
module load cpu/0.15.4
module load gcc/9.2.0
module load cmake/3.18.2
module load openmpi/3.1.6
if [ ! -d build ]; then
	mkdir build
fi
cd build
cmake ..
make
