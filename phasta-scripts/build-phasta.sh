#!/bin/bash
cd 
echo "Cloning Phasta directory..."
if [ ! -d phasta ]; then
	git clone https://github.com/PHASTA/phasta.git
fi

mkdir build 
cd build
cp ~/scc22-scripts/phasta-scripts/helper.sh .
echo "Configuring Phasta..."
. ./helper.sh
echo "Building Phasta executable..."
make -j phastaC.exe

cd
echo "Getting phastaChef tests..."
wget https://fluid.colorado.edu/~kjansen/PHASTA/phastaChefTests.tar.gz
tar -xzf phastaChefTests.tar.gz
