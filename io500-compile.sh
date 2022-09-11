#!/bin/sh -e
echo Cloning repo...
git clone https://github.com/IO500/io500
script_path=$(readlink -f $(dirname "$0"))
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

ls -l --color io500

echo Applying patch
git am "$script_path/0001-modify-io500-script-to-write-and-read-from-scratch-d.patch"

echo && echo $(tput bold && tput setaf 3)Tada!$(tput sgr0)
