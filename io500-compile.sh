#!/bin/sh -e
echo Clonine repo...
git clone https://github.com/IO500/io500
cd io500/

echo Load modules
module purge
module load cpu
module load shared
module load gcc
module load openmpi
module load DefaultModules

echo Compiling, first pass...
./prepare.sh || true

echo Fix linker flags
sed -i "s|^LDFLAGS=\"\"$|LDFLAGS=\"$(mpicxx -showme:link)\"|" build/pfind/compile.sh

echo Compiling, second pass...
./prepare.sh 

echo && echo $(tput bold && tput setaf 3)Tada!$(tput sgr0)
ls -l --color io500
