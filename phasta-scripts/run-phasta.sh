#!/bin/bash
# $1: Number of cores/procs to partition
# $2: native or petsc (types of solver)

# Getting the folder with .geo file (subject to change)
if [ $# -ne 1 ]; then
    echo "Usage: . run-phasta.sh <num-cores>"
    return
fi
cd ~/gmsh_phasta
if [ ! -d AirfoilDemo ]; then
	echo "Getting Airfoil demo..."
	wget https://fluid.colorado.edu/~kjansen/PHASTA/AirfoilDemo.tar
	tar -xvf AirfoilDemo.tar
fi
cd AirfoilDemo
echo "Did you make .gmsh model using Gmsh? Press 1 for YES, 0 for NO"
read GMSH_YES
if [ ${GMSH_YES} == "0" ]; then
	return
fi

rm -rf mdsMsh
echo "Creating .dmg model and mesh to SCOREC/core..."
mpirun -np 1 ~/gmsh_phasta/build/test/from_gmsh none AirfoilDemo.msh mdsMsh/ airfoil.dmg

rm -rf $1-procs_case
cd Chef
echo "Running chef to partition and generate procs_case folder..."
sed -i 's/^splitFactor.*/splitFactor '${1}'/g' adapt.inp
mpirun -np ${1} ~/gmsh_phasta/build/test/chef

export PHASTA_CONFIG=~/phasta/build
echo $PHASTA_CONFIG
if [ ! -f solver.inp.native ]; then
       cp ~/scc22-scripts/phasta-scripts/solver.inp.native .
fi
if [ ! -f solver.inp.petsc ]; then
       cp ~/scc22-scripts/phasta-scripts/solver.inp.petsc .
fi

echo "Press 1 to run with PETSC, Press 0 to run with NATIVE"
read PETSC_YES
if [ ${PETSC_YES} == "1" ]; then 
	cp solver.inp.petsc solver.inp
else 
	cp solver.inp.native solver.inp
fi
echo "Running PHASTA..."
export GMON_OUT_PREFIX=gmon.out-
mpirun -x GMON_OUT_PREFIX -np ${1} $PHASTA_CONFIG/bin/phastaC.exe 

COUNT=`ls -1 *.pht 2>/dev/null | wc -l`
PTH=~/scc22-scripts/phasta-scripts/test.pht
if [ $COUNT == 0 ]; then
	cp $PTH .
fi
