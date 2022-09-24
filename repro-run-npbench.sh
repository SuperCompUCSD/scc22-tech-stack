#!/bin/sh -e
echo Checking if repro-install-npbench.sh has ran
if ! [ -d npbench ]; then
	echo "Error: npbench not found, try running repro-install-npbench.sh"
	exit 1
fi

cd npbench

echo ---
echo Setting up modules
module purge
module load cpu gcc python

echo ---
echo Loading dace venv
. ../dace/repro/bin/activate

echo ---
echo "Running NPBench (it takes long just be patient)"
echo "You might want to get a gpu to run this, but it also works on login node"
echo "Remember to nice -n 19 $0 if running on login node!"
time python quickstart.py
