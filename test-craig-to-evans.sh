#!/bin/bash
/home/testcpu/matt/local/ompi/bin/mpirun \
    -mca btl ^uct,openib \
    -mca pml ucx -x UCX_NET_DEVICES=mlx5_2:1 \
    --hostfile ~/scc22-scripts/hostfile-craig-to-evans.txt \
    --npernode 1 \
    -np 2 \
    /home/testcpu/matt/mpi-benchmarks/IMB-MPI1 PingPong
