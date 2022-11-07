#!/bin/bash
# stolen from Khai
# sm: shared memory byte transfer layer
# openib: infiniband byte transfer layer

/home/testcpu/matt/local/ompi/bin/mpirun \
    -mca btl ^uct,openib \
    -mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 \
    --hostfile /home/testcpu/matt/hostlist-atoc.txt \
    --npernode 1 \
    -np 2 \
    /home/testcpu/matt/mpi-benchmarks/IMB-MPI1 PingPong

