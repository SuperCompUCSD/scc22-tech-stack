#!/bin/bash
# $1: Number of cores/procs to partition
# $2: native or petsc (types of solver)

# Getting the folder with .geo file (subject to change)
cd ~/gmsh_phasta
if [ ! -d AirfoilDemo ]; then
	echo "Getting Airfoil demo..."
	wget https://fluid.colorado.edu/~kjansen/PHASTA/AirfoilDemo.tar
	tar -xvf AirfoilDemo.tar
fi
cd AirfoilDemo
rm -rf mdsMsh
echo "Creating .dmg model and mesh to SCOREC/core..."
mpirun -np ${1} ../build/test/from_gmsh none AirfoilDemo.msh mdsMsh/ airfoil.dmg

rm -rf $1-procs_case
cd Chef
echo "Running chef to partition and generate procs_case folder..."
mpirun -np ${1} ../../build/test/chef

export PHASTA_CONFIG=~/build
echo $PHASTA_CONFIG
#cp solver.inp.$2 solver.inp
echo "Running PHASTA..."
mpirun -np ${1} $PHASTA_CONFIG/bin/phastaC.exe 
