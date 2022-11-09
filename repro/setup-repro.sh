#!/bin/bash

set -e

PATH="/usr/local/miniconda3/bin:$PATH"
ENV_NAME="repro"
REPRO_DIR="$PWD/repro"

echo "Checking for conda env..."

if { conda env list | grep ".*$ENV_NAME.*"; } >/dev/null 2>&1; then
	echo "FOUND ENV $ENV_NAME"
else
	conda create --name $ENV_NAME python=3.8 -y
fi

PYTHON="/home/$(whoami)/.conda/envs/$ENV_NAME/bin/python"

echo 'Creating repro directory...'

mkdir $REPRO_DIR
cd $REPRO_DIR

echo 'Created repro directory!'

echo "INSTALLING DACE"
git clone --recursive https://github.com/spcl/dace
cd "$REPRO_DIR/dace"
$PYTHON -m pip install --editable .
echo "DONE INSTALLING DACE"

cd ..

echo "INSTALLING NPBENCH"
git clone --recursive https://github.com/spcl/npbench
cd "$REPRO_DIR/npbench"
$PYTHON -m pip install -r requirements.txt
$PYTHON -m pip install .
echo "DONE INSTALLING NPBENCH"
#$PYTHON -m pip install numba pythran
#conda install blas numpy mpi4py mkl-include
echo "DONE SETTING UP REPRO SCRIPT"
