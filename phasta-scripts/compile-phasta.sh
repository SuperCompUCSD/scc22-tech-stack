#!/bin/bash
echo "Checking system for gcc, openmpi, cmake, Paraview and Gmsh..."
which gcc
which mpirun
which cmake
which paraview
which gmsh

echo "Running script to build Phasta..."
. ./build-phasta.sh
echo "Running script to build Chef..."
. ./chef-install.sh
echo "Running script to build PETSC..."
. ./petsc-phasta.sh
echo "Done compiling. Use the run.sh script to run PHASTA"
