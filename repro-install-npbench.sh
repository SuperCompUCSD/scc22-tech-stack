#!/bin/sh -e
echo Checking if repro-install-dace.sh has ran
if ! [ -d dace/repro ]; then
	echo "Error: dace/repro not found, try running repro-install-dace.sh"
	exit 1
fi

echo ---
echo Cloning repo...
git clone https://github.com/spcl/npbench
cd npbench

echo ---
echo Setting up modules
module purge
ml cpu
ml gcc
ml python

echo ---
echo Starting the Python venv
. ../dace/repro/bin/activate

echo ---
echo Installing npbench
pip install -r requirements.txt
pip install .

echo ---
echo "Installing numba (necessary but not mentioned in instructions)"
# Otherwise we get
# pkg_resources.DistributionNotFound:
# The 'numba' distribution was not found and is required by the application
pip install numba

echo ---
echo Done
