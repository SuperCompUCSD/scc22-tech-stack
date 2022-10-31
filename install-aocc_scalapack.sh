#!/bin/sh -e

$AOCC_LOC="/opt/AMD/aocc-compiler-3.2.0/lib"

if [ "$(id -u)" -ne 0 ]
then 
    echo "ERROR: Gimme root. (╯‵□′)╯︵┻━┻"
    exit
fi

# Install AOCC first
cd aocc
if [ ! -d "/opt/AMD" ]
then
    dpkg -i aocc-compiler-3.2.0_1_amd64.deb
fi

# Install scalapack, libflame, and blis
cd scalapack
cp ./amd-blis/include/LP64/* $AOCC_LOC
cp ./amd-blis/examples/LP64/* $AOCC_LOC
cp ./amd-blis/lib/LP64/* $AOCC_LOC
cp ./amd-libflame/lib/LP64/* $AOCC_LOC
cp ./amd-scalapack/lib/LP64/* $AOCC_LOC

