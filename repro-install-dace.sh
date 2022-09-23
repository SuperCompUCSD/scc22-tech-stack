#!/bin/sh -e
echo Cloning repo...
git clone --recursive https://github.com/spcl/dace
cd dace

echo ---
echo Setting up modules...
# The same Python version must be used for both installation and executation, and must be >= 3.7,
# or else you get segfault, module not found, or illegal instruction.
module purge
module load cpu
module load gcc
module load python

echo ---
echo Setting up Python venv...
python3 -m venv repro
. repro/bin/activate

echo ---
echo Installing Python...
python -m pip install --editable .

echo ---
echo This should print:
echo Difference: 0.0
echo ---
python samples/simple/axpy.py

echo ---
echo I have no idea what this gets us but something ran.
