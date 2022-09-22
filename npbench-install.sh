#!bin/sh -e
#make sure you only run this after you run the dace-install.sh file
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
echo Starting the python environment
#if it doesn't belong to 
. ~/dace/repro/bin/activate

echo ---
echo Installing npbench
python -m pip install -r requirements.txt
python -m pip install .

echo "run some commands using NPBench"
#You might want to get a gpu to run this, but it also works on login node
echo the process takes long just be patient
python -m pip install numba
python -m pip install dace
python quickstart.py

