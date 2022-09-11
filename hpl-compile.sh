#!/bin/sh -e

echo Extracting files...
tar -xf /cm/shared/examples/sdsc/hpl/hpl-2.3.tar.gz
cd hpl-2.3
cp /cm/shared/examples/sdsc/hpl/Make.GCC.OpenMPI_BLIS .

echo Configuring Makefiles...
# path has to be absolute or shell variables like $HOME; "~" doesn't work
sed -i "s|^TOPdir.*|TOPdir = $PWD|g" Make.GCC.OpenMPI_BLIS

echo Loading modules...
module reset
module load gcc
module load openmpi

echo Compiling...
make arch=GCC.OpenMPI_BLIS

echo && echo $(tput bold && tput setaf 3)Tada!$(tput sgr0)
ls -l --color bin/GCC.OpenMPI_BLIS/
