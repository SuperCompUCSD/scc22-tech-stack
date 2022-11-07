#!/bin/bash

if [ "$(id -u)" -ne 0 ]
then 
    echo "ERROR: Gimme root. (╯‵□′)╯︵┻━┻"
    exit 1
fi

echo "---- Installing AOCC ----"
echo -e "Ctrl+C to cancel within 5 seconds. Starting in 5..."
sleep 1

for (( i=4; i>0; i-- ))
do
    echo -e "$i..."
    sleep 1
done

# Install AOCC first
if [ ! -d "/opt/AMD/aocc-compiler-3.2.0" ]
then
    dpkg -i aocc-compiler-3.2.0_1_amd64.deb
fi

echo "---- Installing AOCC Libraries ----"
echo -e "Ctrl+C to cancel within 3 seconds. Starting in 3..."
sleep 1

for (( i=2; i>0; i-- ))
do
    echo -e "$i..."
    sleep 1
done

# Install scalapack, libflame, and blis
dpkg -i aocl-linux-aocc-3.2.0_1_amd64.deb

echo "---- Finished. ----"
