#!/bin/bash
#SBATCH --job-name="hpcggpu"
#SBATCH --output="hpcg.%j.%N.out"
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --gpus=2
#SBATCH --mem=200000M
#SBATCH --account=sds173
#SBATCH --no-requeue
#SBATCH -t 00:10:00

module reset
module load gpu
module load slurm
module load cuda
module load openmpi

# HPCG Problem Size and Running Time is modified in 'hpcg.dat' 

# For Official Runs, Problem Size must occupy at least 1/4 of 
# main memory and Running Time must be at least 1800s 

# --ntasks-per-node, --gpus, and -np should match
mpirun -np 2 ./xhpcg-3.1_cuda-11_ompi-4.0_sm_60_sm70_sm80 
